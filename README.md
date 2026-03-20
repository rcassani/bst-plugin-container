# Containers in Brainstorm

## Introduction
The idea is that Brainstorm will be able to use (OCI-compliant) containers, if there is a proper container engine in the system.

So this repo has two JSON files to describe plugins:

### 1. Code plugin
The file `code_plugin.json` describes a "code" plugin named `code_plug`, which is comprised by the contents for this repo.

The plugin is comprised by this `README.md` file and the process function `process_os_tag.m`. The later one makes use of the container described in the `cont_plug` plugin to carry the renaming on a file using the name of the OS in the container. 

Note that this plugin has as dependency (field `RequiredPlugs`) the plug in `cont_plug` that is the container plugin.

The two JSON plugin descriptor files are removed on installing `code_plug`.

### 2. Container plugin
The file `cont_plugin.json` describes a container plugin named `cont_plug`, the image reference of this container is the [Alpine Linux](https://hub.docker.com/_/alpine) Docker image.

## Usage

1. You must use the Brainstorm branch `support-containers` in [`rcassani/branstorm3/`](https://github.com/rcassani/brainstorm3)

2. Start Brainstorm

3. Add `code_plug` and `cont_plug` as [user-defined plugins](https://neuroimage.usc.edu/brainstorm/Tutorials/Plugins#User-defined_plugins)

4. [TODO] Install

5. [TODO] Run process
