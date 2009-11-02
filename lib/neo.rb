
class NeoNodeGraph
  def self.session
    begin
      neo = EmbeddedNeo.new("var/neo")
      tx = neo.beginTx
    
      yield self.new(neo)
     
      tx.success
    ensure
      tx.finish      
      neo.shutdown
    end
  end
  
  def initialize neo
    @neo = neo
  end
  
  def create_node attributes
    node = neo.create_node
    attributes.each do |name, value|
      node.set_property name.to_s, value.to_s
    end
    NeoNode.new node
  end
  
  private
  def neo
    @neo
  end
end


class NeoNode
  def initialize node
    @node = node
  end
  
  def method_missing method_id, args
    self.class.send :define_method, method_id do |other_node|
      relationship = DynamicRelationshipType.withName( method_id.to_s )
      @node.create_relationship_to(other_node, relationship)
    end
    
    self.send method_id, args
  end
end