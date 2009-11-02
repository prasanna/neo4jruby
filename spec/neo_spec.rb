require 'spec/spec_helper'

describe NeoNodeGraph do
  it "runs queries" do
    lambda {
      NeoNodeGraph.session do |graph| 
        tim = graph.create_node :first_name => "Tim", :last_name => "Taylor", :nickname => "The Tool Man"
        al = graph.create_node :first_name => "Al", :last_name => "Borland"
      end
    }.should_not raise_error
  end
end

describe NeoNode do
  it "can relate to other nodes" do
    NeoNodeGraph.session do |graph| 
      tim = graph.create_node :first_name => "Tim", :last_name => "Taylor", :nickname => "The Tool Man"
      al = graph.create_node :first_name => "Al", :last_name => "Borland"
      tim.knows al
    end
  end
end