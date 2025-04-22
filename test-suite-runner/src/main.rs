use build_test_cases::get_test_suite;
use domain::*;
use std::collections::HashMap;
use std::error::Error;
use std::fs::File;
use std::io::prelude::*;
use std::process;
mod build_test_cases;
mod domain;

fn main() -> Result<(), Box<dyn Error>> {
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
    let mut test_suite_result: HashMap<String, TestResponse> = HashMap::new();

    let test_suite = get_test_suite()?;
    for positive_test in test_suite.positive_tests().clone() {
        let res = run_test(&positive_test, &scryer_command);
        if let Ok(success) = res {
            println!("{} - {success}", positive_test.name);
            test_suite_result.insert(
                positive_test.name,
                TestResponse {
                    response: success,
                    test_path: positive_test.path,
                },
            );
        } else {
            println!("{}", res.unwrap_err());
            test_suite_result.insert(
                positive_test.name,
                TestResponse {
                    response: false,
                    test_path: positive_test.path,
                },
            );
        }
    }

    for negative_test in test_suite.negative_tests().clone() {
        let res = run_test(&negative_test, &scryer_command);
        if let Ok(failure) = res {
            println!("{} - {}", negative_test.name, !failure);
            test_suite_result.insert(
                negative_test.name,
                TestResponse {
                    response: !failure,
                    test_path: negative_test.path,
                },
            );
        } else {
            println!("{} - {}", negative_test.name, res.unwrap_err());
            test_suite_result.insert(
                negative_test.name,
                TestResponse {
                    response: false,
                    test_path: negative_test.path,
                },
            );
        }
    }
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
