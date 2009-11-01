require 'spec/spec_helper'

describe "neo" do
  it "can initialize embedded neo" do
    class MyRelationshipType
      attr_reader :name
      
      def initialize name
        @name = name
      end
    end
    
    begin
      neo = EmbeddedNeo.new("var/neo")
      tx = neo.beginTx
      
      mr_anderson = neo.create_node
      mr_anderson.set_property "name", "Thomas Anderson"
      mr_anderson.set_property "age", 29
      
      morpheus = neo.create_node
      morpheus.set_property "name", "Morpheus"
      morpheus.set_property "rank", "Captain"
      morpheus.set_property "occupation", "Total bad ass"
      
      trinity = neo.create_node
      trinity.set_property "name", "Trinity"
      
      cypher = neo.create_node
      cypher.set_property "name", "Cypher"
      
      agent_smith = neo.create_node
      agent_smith.set_property "name", "Agent Smith"
      
      architect = neo.create_node
      architect.set_property "name", "Architect"

      KNOWS = MyRelationshipType.new("KNOWS")
      CODED_BY = MyRelationshipType.new("CODED_BY")
      LOVES = MyRelationshipType.new("LOVES")

      relationship = mr_anderson.create_relationship_to( morpheus, KNOWS)
      mr_anderson.create_relationship_to(trinity, KNOWS)
      morpheus.create_relationship_to(trinity, KNOWS)
      morpheus.create_relationship_to(cypher, KNOWS)
      cypher.create_relationship_to(agent_smith, KNOWS)
      agent_smith.create_relationship_to(architect, CODED_BY)
      trinity.create_relationship_to(mr_anderson, LOVES)
      
      friends_traverser = mr_anderson.traverse( 
        Traverser::Order::BREADTH_FIRST, 
        StopEvaluator::END_OF_NETWORK, 
        ReturnableEvaluator::ALL_BUT_START_NODE, 
        KNOWS, 
        Direction::OUTGOING )
      
      expected_friends = [
        {:depth => 1, :name => "Morpheus"},
        {:depth => 1, :name => "Trinity"},
        {:depth => 2, :name => "Cypher"},
        {:depth => 3, :name => "Agent Smith"}]

      friends_traverser.each_with_index do |friend, i|
        friends_traverser.current_position.depth.should == expected_friends[i][:depth]
        friend.get_property('name').should == expected_friends[i][:name]
      end
      
      
      class LoveReturnableEvaluator
        include ReturnableEvaluator
        def isReturnableNode( pos ) 
          return pos.currentNode().hasRelationship(LOVES, Direction::OUTGOING)
        end
      end
      
      
      love_traverser = mr_anderson.traverse( 
        Traverser::Order::BREADTH_FIRST, 
        StopEvaluator::END_OF_NETWORK, 
        LoveReturnableEvaluator.new,
        KNOWS, 
        Direction::OUTGOING )
        
      love_traverser.each do |lover|
        love_traverser.current_position.depth.should == 1
        lover.get_property('name').should == "Trinity"
      end
      
      tx.success
    ensure
      tx.finish      
      neo.shutdown
    end
  end
end