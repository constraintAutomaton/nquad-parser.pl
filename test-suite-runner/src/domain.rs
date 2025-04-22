use crate::build_test_cases::BASE_IRI;
use oxigraph::model::Term;
use serde::Serialize;
use std::{error::Error, path::PathBuf};

#[derive(Serialize)]
pub struct TestResponse {
    pub response: bool,
    pub test_path: PathBuf,
}

#[derive(Debug)]
pub struct PrologError {
    pub message: String,
}

impl Error for PrologError {}

impl std::fmt::Display for PrologError {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(f, "{}", self.message)
    }
}
#[derive(Clone)]
pub struct Command {
    pub program: String,
    pub arguments: [String; 3],
}
#[derive(Clone)]
pub struct TestSuite {
    positive_tests: Vec<TestCase>,
    negative_tests: Vec<TestCase>,
}

#[derive(Clone)]
pub struct TestCase {
    pub name: String,
    pub path: PathBuf,
}

impl TestSuite {
    pub fn positive_tests(&self) -> &Vec<TestCase> {
        &self.positive_tests
    }

    pub fn negative_tests(&self) -> &Vec<TestCase> {
        &self.negative_tests
    }

    pub fn from_terms(
        positive_test_files: Vec<[Term; 2]>,
        negative_test_files: Vec<[Term; 2]>,
        path_w3c_test_suite: &PathBuf,
    ) -> Self {
        let transform_function = |terms: &[Term; 2]| {
            let name = {
                if let Term::Literal(literal) = &terms[1] {
                    literal.value().to_string()
                } else {
                    panic!("each test cases should have a name")
                }
            };

            let path = {
                if let Term::NamedNode(named_node) = &terms[0] {
                    let path = {
                        let mut resp = path_w3c_test_suite.clone();
                        let iri = {
                            let mut resp = named_node.clone().into_string();
                            resp = resp.replacen(BASE_IRI, "", 1);
                            resp = resp.replacen("<", "", 1);
                            resp = resp.replacen(">", "", 1);
                            resp
                        };
                        resp.push(iri);
                        resp
                    };
                    path
                } else {
                    panic!("the query should return only named node with an iri representing the path of the test cases");
                }
            };
            TestCase { name, path }
        };
        Self {
            positive_tests: positive_test_files.iter().map(transform_function).collect(),
            negative_tests: negative_test_files.iter().map(transform_function).collect(),
        }
    }
}
