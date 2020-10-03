# DSL

The DSL provides a convenient way to declare all system components:
* The node
* Layers
* NaniteTemplates

Using the DSL creates declaration objects which will in turn be used to create concrete objects, e.g. layers using factory classes. Declaration objects are stored in the module's namespace. Factories use names defined in the declaration object to identify the object to use.
The expection is the DSL method 

```create```: This method actually creates concrete objects.

## Node DSL

### Example

Declare a node with name ':node_1':

```ruby
NanoMind.node :node_1 do
  # add layers
  add :layer_1, using: LocalLayer # without block, it assumes the layer is existing at creation. 'Using' defines the class of layer, 'LocalLayer' is the default
  add :layer_2 do # with block, the layer will be declared and registered
    # use Layer DSL in this block
    nanites using: NaniteTemplate2
    output to: OutputStackAdapter
    input from: InputStackAdapter
  end
  
  ### define dataflow
  # Layers used in the dataflow may not exist atm, but have to be existing
  # when creating the node
  data_flow do
    # where should we start?
    start with: :layer_1
    # Relations can be 1:1 ...
    from :layer_1, to: :layer_2
    # ... or 1:n
    from :layer_3, to: [:layer_4, :layer_5]
    # the direction doesn't matter
    from :layer_2, to: :layer_1
  end
end
```

## Layer DSL

### Example

Declare a layer with name ':layer_1':

```ruby
NanoMind.layer :layer_1 do
    # Define the template the nanites will be using
    # Optional: the max. number of nanites in the layer (defaults to 4) and keep_alive (defaults to false)
    nanites max_number: 4, keep_alive: false, using: NaniteTemplate1
    # Where shall the output go to?
    output to: OutputStackAdapter
    # Where does the input come from?
    input from: InputStackAdapter
    # Register event handler to one or more events
    register handler: SomeHandler, to: :after_creation
    # Procs/Lambdas can be registered as well
    register handler: proc{}, to: [:before_nanite_creation, :after_nanite_creation]
end
```

## Creation

Using ```create ``` you can create the concrete objects, actually setting up the system declared:

```ruby 
p1 = create :node_1
```

This creates the Node object p1 and subsequently declared objects like layers and nanites.


## Manipulation

The manipulation DSL is used to manipulate system components at runtime. As with the other DSLs (except 'creation'), a declaration object is created which need to be applied to a specific object.
The declaration is stored in the NanoMind namespace as well (which comes in handy for later use, or a rollback).

This feature is pretty useful: Imagine you have a predictable resource utilization at a given time. Just predefine a manipulation raising the max. numbers of nanites in the layer concerned. After the utilization goes back to normal, rollback the manipulation.

### Example

```ruby
NanoMind.manipulate :manipulate_layers_in_node do
    # Add a layer
    add :layer_N
    # Replace layers
    replace :layer_1, with: :layer_M
    # Remove a layer
    remove :layer_2

    # Obviously, the data flow needs a refreshment now too:
    data_flow do
        # Relations can be 1:1 ...
        from :layer_1, to: :layer_3
        # ... or 1:n
        from :layer_3, to: [:layer_4, :layer_5]
    end
end
```

Now the manipulation is defined and can be applied on a concrete object:

```ruby
# Now apply the manipulation to a concrete object
NanoMind.apply manipulation: :manipulate_layers_in_node, to: :node_1
```

In case you want to undo the manipulation:

```ruby
# Manipulations are stored, so they can be rolled back, if necessary:
NanoMind.rollback manipulation: :manipulate_layers_in_node, applied_on: :node_1
```

***NOTE:*** Layers are locked while being manipulated (or when a manipulation is undone).