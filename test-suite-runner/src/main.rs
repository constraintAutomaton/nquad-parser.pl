use build_test_cases::get_test_suite;
use domain::*;
use std::collections::HashMap;
use std::error::Error;
use std::process;
mod build_test_cases;
mod domain;

fn main() -> Result<(), Box<dyn Error>> {
    let mut test_suite_result: HashMap<String, bool> = HashMap::new();
    let scryer_command: Command = Command {
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
    };

    let test_suite = get_test_suite()?;

    for positive_test in test_suite.positive_tests() {
        let res = run_test(positive_test, &scryer_command);
        if let Ok(success) = res {
            test_suite_result.insert(positive_test.name.clone(), success);
            println!("{success}");
        } else if let Err(err) = res {
            test_suite_result.insert(positive_test.name.clone(), false);
            println!("{}", err);
        }
    }

    for negative_test in test_suite.negative_tests() {
        let res = run_test(negative_test, &scryer_command);
        if let Ok(failure) = res {
            test_suite_result.insert(negative_test.name.clone(), !failure);
            println!("{}", !failure);
        } else if let Err(err) = res {
            test_suite_result.insert(negative_test.name.clone(), false);
            println!("{}", err);
        }
    }

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
