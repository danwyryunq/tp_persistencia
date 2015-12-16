package amigos;

import org.neo4j.graphdb.RelationshipType;

public enum TipoDeRelaciones implements RelationshipType {
	AMIGO,ENVIA,RECIBE
}