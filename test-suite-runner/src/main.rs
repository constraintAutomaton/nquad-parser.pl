use oxigraph::sparql::QueryResults;
use oxigraph::store::Store;
use oxrdfio::{RdfFormat, RdfParser};
use std::error::Error;
use std::fs;
use std::path::PathBuf;

fn main() -> Result<(), Box<dyn Error>> {
    let file_path = PathBuf::from("./manifest.ttl");
    let file = fs::read_to_string(file_path)?;
    let store = Store::new()?;

    store.load_from_reader(
        RdfParser::from_format(RdfFormat::Turtle).with_base_iri("http://example.com")?, // we put the file default graph inside of a named graph
        file.as_bytes(),
    )?;

    if let QueryResults::Solutions(solutions) = store.query(QUERY)? {
        for solution in solutions {
            let solution = solution?;
            println!("{solution:?}");
        }
    }

    Ok(())
}

const QUERY: &'static str = r#"
PREFIX mf: <http://www.w3.org/2001/sw/DataAccess/tests/test-manifest#>
PREFIX qt: <http://www.w3.org/2001/sw/DataAccess/tests/test-query#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdft:   <http://www.w3.org/ns/rdftest#> 

SELECT ?positiveTestFile ?negativeTestFile WHERE{
    ?s mf:entries ?entries.
    ?entries rdf:rest*/rdf:first ?entry.
    {
    ?entry a rdft:TestNQuadsPositiveSyntax;
        mf:action ?positiveTestFile
    } UNION {
        ?entry a rdft:TestNQuadsNegativeSyntax;
            mf:action ?negativeTestFile
    }
}
"#;
