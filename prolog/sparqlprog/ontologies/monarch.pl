/*

  
*/

:- module(monarch,
          [
           disease_to_phenotype_SD/2,
           disease_to_phenotype_EE/4,
           disease_to_phenotype_EE/2,

           disease_to_phenotype_SX/4
           ]).

:- use_module(library(sparqlprog)).
:- use_module(library(semweb/rdf11)).

%:- sparql_endpoint( monarch, 'http://rdf.monarchinitiative.org/sparql').

:- rdf_register_prefix(foaf,'http://xmlns.com/foaf/0.1/').
:- rdf_register_prefix(obo,'http://purl.obolibrary.org/obo/').
:- rdf_register_prefix(mondo,'http://purl.obolibrary.org/obo/MONDO_').
:- rdf_register_prefix(so,'http://purl.obolibrary.org/obo/SO_').
:- rdf_register_prefix(bds,'http://www.bigdata.com/rdf/search#').

id_uri(ID,URI) :-
        concat_atom([Pre,Frag],':',ID),
        concat_atom(['http://purl.obolibrary.org/obo/',Pre,'_',Frag],URI).


user:term_expansion(pname_id(P,Id),
                    [(   Head :- Body),
                     (:- initialization(export(P/2), now))
                     ]) :-
        Head =.. [P,S,O],
        id_uri(Id,Px),
        Body = rdf(S,Px,O).

user:term_expansion(cname_id(C,Id),
                    [Rule,
                     RuleInf,
                     RuleIsa,
                     (:- initialization(export(InfC/1), now)),
                     (:- initialization(export(SubC/1), now)),
                     (:- initialization(export(C/1), now))
                     ]) :-
        id_uri(Id,Cx),
        
        Head =.. [C,I],
        Body = rdf(I,rdf:type,Cx),
        Rule = (Head :- Body),
        
        atom_concat(C,'_inf',InfC),
        Head2 =.. [InfC,I],
        Body2 = rdfs_individual_of(I,Cx),
        RuleInf = (Head2 :- Body2),
        
        atom_concat('isa_',C,SubC),
        Head3 =.. [SubC,I],
        Body3 = rdfs_subclass_of(I,Cx),
        RuleIsa = (Head3 :- Body3).


disease_to_phenotype_EE(D,P) :-
        disease_to_phenotype_EE(D,P,_,_).
disease_to_phenotype_EE(D,P,Dx,Px) :-
        owl_equivalent_class(D,Dx),
        has_phenotype(Dx,Px),
        owl_equivalent_class(Px,P).

disease_to_phenotype_ED(D,P) :-
        owl_equivalent_class(D,Dx),
        has_phenotype(Dx,P).

disease_to_phenotype_SD(D,P) :-
        rdfs_subclass_of(Ds,D),
        owl_equivalent_class(Ds,Dx),
        has_phenotype(Dx,P).

disease_to_phenotype_SX(D,P,Dx,Px) :-
        rdfs_subclass_of(Ds,D),
        owl_equivalent_class(Ds,Dx),
        has_phenotype(Dx,Px),
        owl_equivalent_class(Px,P).

        
        


% cut -f1,2 biolink-model.tsv | grep : | perl -npe 's@\|SIO:\d+@@' | tbl2p -p cname_id

cname_id('individual_organism', 'SIO:010000').
cname_id('disease', 'MONDO:0000001').
cname_id('phenotypic_feature', 'UPHENO:0000001').
cname_id('confidence_level', 'CIO:0000028').
cname_id('evidence_type', 'ECO:0000000').
cname_id('publication', 'IAO:0000311').
cname_id('chemical_substance', 'SIO:010004').
cname_id('genomic_entity', 'SO:0000110').
cname_id('genome', 'SO:0001026').
cname_id('transcript', 'SO:0000673').
cname_id('exon', 'SO:0000147').
cname_id('coding_sequence', 'SO:0000316').
cname_id('gene', 'SO:0000704').
cname_id('protein', 'PR:000000001').
cname_id('RNA_product', 'CHEBI:33697').
cname_id('microRNA', 'SO:0000276').
cname_id('macromolecular_complex', 'GO:0032991').
cname_id('gene_family', 'NCIT:C20130').
cname_id('zygosity', 'GENO:0000133').
cname_id('sequence_variant', 'GENO:0000512').
cname_id('drug_exposure', 'ECTO:0000509').
cname_id('treatment', 'OGMS:0000090').
cname_id('molecular_activity', 'GO:0003674').
cname_id('biological_process', 'GO:0008150').
cname_id('cellular_component', 'GO:0005575').
cname_id('cell', 'GO:0005623').
