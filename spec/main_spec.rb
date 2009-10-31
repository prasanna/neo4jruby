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
      firstNode = neo.createNode
      secondNode = neo.createNode
      relationship = firstNode.createRelationshipTo( secondNode, KNOWS = MyRelationshipType.new("KNOWS"))
      
      firstNode.setProperty( "message", "Hello, " )
      secondNode.setProperty( "message", "world!" )
      relationship.setProperty( "message", "brave Neo " )
      
      puts firstNode.getProperty( "message" )
      puts relationship.getProperty("message")
      puts secondNode.getProperty("message")
      
      tx.success
    ensure
      tx.finish      
      neo.shutdown
    end
  end
end