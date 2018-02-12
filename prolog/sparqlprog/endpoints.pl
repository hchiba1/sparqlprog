:- module(endpoints,
          []).
:- use_module(library(sparqlprog)).

:- sparql_endpoint( dbp, 'http://dbpedia.org/sparql/').
:- rdf_register_prefix(dbont,'http://dbpedia.org/ontology/').
:- sparql_endpoint( wd, 'http://query.wikidata.org/sparql').
:- sparql_endpoint( go, 'http://rdf.geneontology.org/sparql').
:- sparql_endpoint( monarch, 'http://rdf.monarchinitiative.org/sparql').
:- sparql_endpoint( uniprot, 'http://sparql.uniprot.org/sparql').
:- sparql_endpoint( dbpedia, 'http://dbpedia.org/sparql/').

:- sparql_endpoint( local, 'http://127.0.0.1:8889/bigdata/sparql').
    