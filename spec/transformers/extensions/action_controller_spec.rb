require 'spec_helper'

#TODO: Find why adding transform_params in individual spec definition fails and fix it.
class TestActionController < ActionController::Base
  include Rails.application.routes.url_helpers
  transform_params { convert :foo, :to => :upcase }

  transform_params :bar do
    convert :foo, :to => :upcase
  end

  transform_params :baz, :only => :index do
     convert :foo, :to => :upcase
  end

  def index; head :ok; end
  def show; head :ok; end
end

describe TestActionController, :type => :controller do
  describe "transform_params" do
    context "without args" do
      it "transforms params by default" do
        get :index, :foo => "hello"

        controller.params[:foo].should == "HELLO"
      end
    end

    context "with a key name as param" do
      it "transforms params[key]" do
        get :index, :bar => {:foo => "hello"}

        controller.params[:bar][:foo].should == "HELLO"
      end
    end

    context "with additional options" do
      it "should pass the options to before filter" do
        get :index, :baz => {:foo => "hello"}
        controller.params[:baz][:foo].should == "HELLO"

        get :show, :baz => {:foo => "hello"}
        controller.params[:baz][:foo].should == "hello"
      end
    end
  end
end
