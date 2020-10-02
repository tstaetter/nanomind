# NanoMind

A framework providing an easy way of splitting up complex tasks into many simple ones and organizing them. The framework will provide features for automatically improving the performance of the running instance, using ML and Deep Learning.
Performance improvements can vary from the automatic raise of nanites per layer before predicted utilization peaks to adding/removing layers for e.g. security improvements.

## Nanite Templates

Templates are the blueprint for a specific type of nanites, providing basic functionality, e.g.
the action to be performed on the input. But templates can go far beyond that, by providing 
features like inter-communication of nanites (just an example).

## Nanites

A nanite is an object performing only one (simple) action. Usually, a nanite is a thread, if the NanoMind 
instance is running on one machine (e.g. locally at development), but they're not
limited to. Nanites can run locally or remote, where remote means in a separate process or a different machine.
Remote nanites can be provided using any language, even FaaS can be used (e.g. AWS lambda) as
long as they can register to a layer and send their output there.
Every nanite expects an input, applies it's action on it and then pushes it's output to the layer
it's living in. More advanced things can happen in a nanites lifecycles, it depends on the template
the nanite was created with.

### Events

For now, these events are available, the template can provide methods for:
- after_creation
- before_action
- after_action
- before_dying

Handlers can be registered for the given events either inside the template or inside the layer definition.

## Layers

Layers organize nanites of the same type (i.e. using the same Template). Basically, layers can
be written in any language, as long as they can register to a NanoMind node.
The core purpose of a layer is creating/maintaing nanites, providing the input and optional runtime parameters to them and handling
their output. The layer definition decides, if a nanite keeps running after processing it's input,
or if nanites are created on demand.
A layer has a defined maximum number of nanites, no matter if they stay alive or not. E.g. a max number
of 4 nanites mean either 4 nanites running concurrently, or the layer can create a max. number of 4 
nanites. If no more nanites are available (meaning no more nanites can be created, or all running nanites
are busy) the input will be held in a stack.
Layers send maintenance information to their node, i.e. it reports "max. number of nanites reached", so
the user is able to react and raise the max. number of nanites at runtime. 
In later releases, Layers will use plug-ins for their stacks and for communicating with their nanites.

Layers live independently, meaning each layer doens't have a reference to the others. The node controls the dataflow from one layer to another. Therefore, layers can be running remote as well. 

### Events

Layers provides events, too. Handlers can be registered inside the node.
Following events are provided:
- after_creation
- before_nanite_creation
- after_nanite_creation
- before_deletion

### Input stack

The input stack is implemented in an adaptable way, so a simple array can be used as well as a full message queue like RabbitMQ, or some database. Input stacks are expected to actively push new data to the layer they are assigned on.

### Output stack

Every nanite pushes it's ouput to the layer's ouput stack. Like the input, the output stack will be implemented
in an adaptable way, so simple objects or complex systems can be used interchangeably.

## Node

A node is a collection of layers, organizaning them. In this context, organizing means:
* Creation/Registration of layers
* Provide communication bridge between layers
* Provide access to the insights of a layer (and their nanites)
* Collect metrics data used for training models to be able to predict the system status under certain circumstances

As a nanite, nodes can be understood as black boxes, where you put something in, expecting some output, after all the nanites have done their work.

## Manager

The manager is an application used for visualizing and maintaining existing layers in a node. Using the manager,
nodes can be edited at runtime. The user can add/remove/edit layers, e.g. raising the max. number of nanites in a specific layer. The manager provides a UI as well as an API for performing tasks.

# Roadmap

The release roadmap predefines the version features (using Semantic Versioning as described on https://semver.org)
planned so far:
* **0.1.0-alpha** Alpha version providing the most basic features
* **0.1.X-alpha** Several patches may appear
* **0.1.0-beta** Ready for test
* **0.1.X-beta** Several patches may appear
* **0.1.0 First** release of the basic features.


# TODOs

* How to deal with events on remote nanites/layers?
* TBC