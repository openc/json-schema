require File.expand_path('../test_helper', __FILE__)

class JSONSchemaTest < Minitest::Test

  #
  # These tests are ONLY run if there is an appropriate JSON backend parser available
  #

  def test_schema_from_file
    assert_valid schema_fixture_path('good_schema_1.json'), { "a" => 5 }
    refute_valid schema_fixture_path('good_schema_1.json'), { "a" => "bad" }
  end

  def test_data_from_file
    schema = {"$schema" => "http://json-schema.org/draft-03/schema#","type" => "object", "properties" => {"a" => {"type" => "integer"}}}
    assert_valid schema, data_fixture_path('good_data_1.json'), :uri => true
    refute_valid schema, data_fixture_path('bad_data_1.json'), :uri => true
  end

  def test_data_from_json
    if JSON::Validator.json_backend != nil
      schema = {"$schema" => "http://json-schema.org/draft-03/schema#","type" => "object", "properties" => {"a" => {"type" => "integer"}}}
      assert_valid schema, %Q({"a": 5}), :json => true
      refute_valid schema, %Q({"a": "poop"}), :json => true
    end
  end

  def test_both_from_file
    assert_valid schema_fixture_path('good_schema_1.json'), data_fixture_path('good_data_1.json'), :uri => true
    refute_valid schema_fixture_path('good_schema_1.json'), data_fixture_path('bad_data_1.json'), :uri => true
  end

  def test_file_ref
    assert_valid schema_fixture_path('good_schema_2.json'), { "b" => { "a" => 5 } }
    refute_valid schema_fixture_path('good_schema_1.json'), { "b" => { "a" => "boo" } }
  end

  def test_file_extends
    assert_valid schema_fixture_path('good_schema_extends1.json'), { "a" => 5 }
    assert_valid schema_fixture_path('good_schema_extends2.json'), { "a" => 5, "b" => { "a" => 5 } }
  end

end
