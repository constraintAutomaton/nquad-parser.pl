use build_test_cases::get_test_suite;
use domain::*;
use std::collections::HashMap;
use std::error::Error;
use std::fs::File;
use std::io::prelude::*;
use std::path::PathBuf;
use std::process;
mod build_test_cases;
mod domain;

fn main() -> Result<(), Box<dyn Error>> {
    generate_prolog_test()?;
    Ok(())
}

fn rust_runner() -> Result<(), Box<dyn Error>> {
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
    let mut n_success = 0usize;
    for positive_test in test_suite.positive_tests().clone() {
        let res = run_test(&positive_test, &scryer_command);
        if let Ok(success) = res {
            if success {
                n_success += 1;
            }
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
            if !failure {
                n_success += 1;
            }
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

    let summary = format!(
        "There are {n_success} out of {n_test} test that passed",
        n_test = test_suite.negative_tests().len() + test_suite.positive_tests().len()
    );

    println!("\n\n\n{summary}");

    let mut file = File::create("./summary")?;
    file.write_all(summary.as_bytes())?;

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

fn generate_prolog_test() -> Result<(), Box<dyn Error>> {
    let test_suite = get_test_suite()?;
    let mut terms: Vec<String> = Vec::new();
    for test in test_suite.positive_tests().iter() {
        terms.push(generate_prolog_test_term(test, true));
    }

    for test in test_suite.negative_tests() {
        terms.push(generate_prolog_test_term(test, false));
    }

    let mut file_template_string = String::new();

    let mut file_template = File::open(PathBuf::from("./unit_test_template"))?;
    let _ = file_template.read_to_string(&mut file_template_string)?;

    let prolog_terms = terms.join("\n");

    file_template_string.push_str(&prolog_terms);

    let mut file = File::create("./unit_test.pl")?;
    file.write_all(file_template_string.as_bytes())?;

    Ok(())
}

fn generate_prolog_test_term(test_case: &TestCase, positive: bool) -> String {
    let TestCase { name, path } = test_case;
    let file = path.to_str().unwrap();
    let positive_or_negative = if positive {
        String::new()
    } else {
        r"\+".to_string()
    };
    format!(r#"test("{name}", ({positive_or_negative}once(phrase_from_file(nquad_doc, '{file}'))))."#)
}
