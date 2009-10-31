require 'java'


Dir["vendor/lib/*.jar"].each { |jar| require jar }

import org.neo4j.api.core.EmbeddedNeo
import org.neo4j.api.core.RelationshipType