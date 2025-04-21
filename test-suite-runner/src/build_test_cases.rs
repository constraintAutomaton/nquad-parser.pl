use crate::domain::*;
use oxigraph::model::Term;
use oxigraph::sparql::QueryResults;
use oxigraph::store::Store;
use oxrdfio::{RdfFormat, RdfParser};
use std::error::Error;
use std::fs;
use std::path::PathBuf;

pub fn get_test_suite() -> Result<TestSuite, Box<dyn Error>> {
    let path_w3c_test_suite = PathBuf::from("./w3c_test_suite");
    let file_path = PathBuf::from("./manifest.ttl");
    let file = fs::read_to_string(file_path)?;
    let store = Store::new()?;
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
    Ok(TestSuite::from_terms(
        positive_test_files,
        negative_test_files,
        &path_w3c_test_suite,
    ))
}

pub const BASE_IRI: &'static str = "http://example.com/";

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
        mf:action ?positiveTestFile ;
        mf:name ?name .

    } UNION {
        ?entry a rdft:TestNQuadsNegativeSyntax;
            mf:action ?negativeTestFile ;
            mf:name ?name .
    }
}
"#;
