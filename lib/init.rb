require 'java'


Dir["vendor/lib/*.jar"].each { |jar| require jar }

import org.neo4j.api.core.EmbeddedNeo
import org.neo4j.api.core.RelationshipType
import org.neo4j.api.core.DynamicRelationshipType
import org.neo4j.api.core.Traverser
import org.neo4j.api.core.StopEvaluator
import org.neo4j.api.core.ReturnableEvaluator
import org.neo4j.api.core.Direction
