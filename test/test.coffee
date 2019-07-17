expect    = require 'expect'
hcltojson = require '../src'


describe 'hcltojson', ->

  it 'should return empty object if no input provided', ->
    expect(hcltojson('')).toEqual {}

  it 'should support basic assignments', ->
    expect(hcltojson 'foo = "bar"').toEqual {foo: "bar"}


describe 'hcl sample tests', ->

  hclSamples     = require './hcl-samples'
  hclSamplesJSON = require './hcl-samples-json'

  [0...hclSamples.length].forEach (i) ->
    it "testing sample #{i}", ->
      hcl = hclSamples[i]
      json = hclSamplesJSON[i]
#      console.log {hcl, json: JSON.stringify json }
      expect(hcltojson hcl).toEqual json
