use oxigraph::model::Term;
use oxigraph::sparql::QueryResults;
use oxigraph::store::Store;
use oxrdfio::{RdfFormat, RdfParser};
use std::collections::HashMap;
use std::error::Error;
use std::fs;
use std::path::PathBuf;
use std::process;

fn main() -> Result<(), Box<dyn Error>> {
    let path_w3c_test_suite = PathBuf::from("./w3c_test_suite");
    let file_path = PathBuf::from("./manifest.ttl");
    let file = fs::read_to_string(file_path)?;
    let store = Store::new()?;
    let results: HashMap<String, bool> = HashMap::new();
    let scryer_command: Command = Command {
        program: "scryer-prolog",
        arguments: vec![
            "-g",
            r#""use_module(library(pio)), ((once(phrase_from_file(nquad_doc, '{}')), write(true)) ; write(false)), nl, halt""#,
            "./nquad"
        ],
    };

    store.load_from_reader(
        RdfParser::from_format(RdfFormat::Turtle).with_base_iri(BASE_IRI)?,
        file.as_bytes(),
    )?;

    let mut positive_test_files: Vec<[Term; 2]> = Vec::new();
    let mut negative_test_files: Vec<[Term; 2]> = Vec::new();
    if let QueryResults::Solutions(solutions) = store.query(QUERY)? {
        for solution in solutions {
            let solution = solution?;
            if let Some(name) = solution.get("name") {
                if let Some(term) = solution.get("positiveTestFile") {
                    positive_test_files.push([term.clone(), name.clone()]);
                }
                if let Some(term) = solution.get("negativeTestFile") {
                    negative_test_files.push([term.clone(), name.clone()]);
                }
            }
        }
    }
    let test_cases = TestSuite::from_terms(
        positive_test_files,
        negative_test_files,
        &path_w3c_test_suite,
    );

    Ok(())
}

fn run_test(test_case: TestCase, command: Command) -> bool {
    let TestCase { path, name } = test_case;

    let mut child ={
        let mut resp = process::Command::new(command.program);
        for arg in command.arguments{
            resp.arg(arg);
        }
        resp.spawn().unwrap();

        resp
    };
    
    println!("{}",child.status().unwrap());


    true
}
struct Command<'a> {
    pub program: &'a str,
    pub arguments: Vec<&'a str>,
}

const COMMAND: &'static str = r#"scryer-prolog -g "use_module(library(pio)), ((once(phrase_from_file(nquad_doc, '{}')), write(true)) ; write(false)), nl, halt" ./nquad"#;
const BASE_IRI: &'static str = "http://example.com/";

const QUERY: &'static str = r#"
PREFIX mf: <http://www.w3.org/2001/sw/DataAccess/tests/test-manifest#>
PREFIX qt: <http://www.w3.org/2001/sw/DataAccess/tests/test-query#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdft:   <http://www.w3.org/ns/rdftest#> 

SELECT ?positiveTestFile ?negativeTestFile ?name WHERE{
    ?s mf:entries ?entries.
    ?entries rdf:rest*/rdf:first ?entry.
    {
    ?entry a rdft:TestNQuadsPositiveSyntax;
        mf:action ?positiveTestFile
        mf:name ?name

    } UNION {
        ?entry a rdft:TestNQuadsNegativeSyntax;
            mf:action ?negativeTestFile
            mf:name ?name
    }
}
"#;

struct TestSuite {
    positive_tests: Vec<TestCase>,
    negative_tests: Vec<TestCase>,
}

struct TestCase {
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
                if let Term::NamedNode(named_node) = &terms[1] {
                    named_node.clone().into_string()
                } else {
                    panic!("each test cases should have a name")
                }
            };

            let path = {
                if let Term::NamedNode(named_node) = &terms[0] {
                    let path = {
                        let mut resp = path_w3c_test_suite.clone();
                        resp.push(named_node.clone().into_string());
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
