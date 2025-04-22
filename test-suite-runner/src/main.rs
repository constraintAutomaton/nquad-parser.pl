use build_test_cases::get_test_suite;
use domain::*;
use std::collections::HashMap;
use std::error::Error;
use std::fs::File;
use std::io::prelude::*;
use std::process;
use std::sync::Arc;
use std::thread;
mod build_test_cases;
mod domain;

fn main() -> Result<(), Box<dyn Error>> {
    let scryer_command: Arc<Command> = Arc::new(Command {
        program: "scryer-prolog".into(),
        arguments: [
            "-g".into(),
            r#"use_module(library(pio)),
             ((once(phrase_from_file(nquad_doc, '{}')), write(true))
              ; 
              write(false)),
                halt."#
                .into(),
            "./prolog/nquad.pl".into(),
        ],
    });

    let test_suite = get_test_suite()?;
    let mut threads = Vec::new();
    for positive_test in test_suite.positive_tests().clone() {
        let command_to_thread = scryer_command.clone();
        let thread_join_handle = thread::spawn(move || {
            let res = run_test(&positive_test, command_to_thread.as_ref());
            if let Ok(success) = res {
                println!("{} - {success}", positive_test.name);
                (positive_test.name, success)
            } else {
                println!("{}", res.unwrap_err());
                (positive_test.name, false)
            }
        });
        threads.push(thread_join_handle);
    }

    for negative_test in test_suite.negative_tests().clone() {
        let command_to_thread = scryer_command.clone();
        let thread_join_handle = thread::spawn(move || {
            let res = run_test(&negative_test, command_to_thread.as_ref());
            if let Ok(failure) = res {
                println!("{} - {}", negative_test.name, !failure);
                (negative_test.name, !failure)
            } else {
                println!("{} - {}", negative_test.name, res.unwrap_err());
                (negative_test.name, false)
            }
        });
        threads.push(thread_join_handle);
    }

    let test_suite_result: HashMap<String, bool> =
        threads.into_iter().map(|t| t.join().unwrap()).collect();

    let json = serde_json::to_string_pretty(&test_suite_result).unwrap();

    let mut file = File::create("./test_result.json")?;
    file.write_all(json.as_bytes())?;

    Ok(())
}

fn run_test(test_case: &TestCase, command: &Command) -> Result<bool, Box<dyn Error>> {
    let TestCase { path, name } = test_case;
    println!("---- test {name} running ----",);

    let child = {
        let mut resp = process::Command::new("timeout");
        resp.arg("1s");
        resp.arg(&command.program);
        for arg in &command.arguments {
            resp.arg(arg.replacen("{}", path.to_str().unwrap(), 1));
        }
        resp.output()?
    };

    let stdout = String::from_utf8(child.stdout)?;
    let stderr = String::from_utf8(child.stderr)?;
    if !stderr.is_empty() {
        Err(Box::new(PrologError { message: stderr }))
    } else {
        if stdout == "true" {
            Ok(true)
        } else {
            Ok(false)
        }
    }
}
