## Synapse Shiny App Template

**This branch is meant to live separately to illustrate the reticulate alternative. It should not be merged**

Basic Shiny application for use on Sage Bionetwork's Synapse web portal.

This variation of SynapseShinyApp accesses Synapse using the [reticulate](https://rstudio.github.io/reticulate/) library in conjunction with the Python [synapseclient](https://github.com/Sage-Bionetworks/synapsePythonClient) as an alternative to using the [synapser](https://github.com/Sage-Bionetworks/synapser) R package.

Please first see the [master](https://github.com/Sage-Bionetworks/SynapseShinyApp/tree/master) branch of this repository for an initial understanding of how the base version of this application works with synapser as that will help illustrate the differences when using reticulate and the Python synapseclient instead.

## Setup

### Python

synapseclient requires a Python installation of > 3.6, and reticulate additionally requires that the python installation have been built with the **--enabled-shared** option. If you already have python installed, you can check its suitability by running e.g. the following command.

```
python3 -c "import platform; import sysconfig; print(platform.python_version()); print(sysconfig.get_config_vars('Py_ENABLE_SHARED'))"
```

The output of running this command should be a version on the first line and a number on the second [0] or [1] indicating that Python was compiled with the necessary support needed by reticulate, e.g.

```
3.8.2
[1]
```

If the output of the above indicates you have a Python version > 3.6 and shows [1], then you have a suitable Python available for running reticulate and can move to the next section.

If you received an error running the command, the version was < 3.6, or you received [0], then a different installation of Python is necessary to run reticulate. If that is the case, one way of making a new Python installation available is using [pyenv](https://github.com/pyenv/pyenv#installation).

With pyenv installed, you can install a reticulate suitable Python with e.g. the following:
```
env PYTHON_CONFIGURE_OPTS="--enable-shared" pyenv install 3.8.2
```

Then configure the local repository directory to use the  new version e.g.:
```
# from the SynapseShinyApp repository directory
pyenv local 3.8.2
```

### Python dependencies

Once you have a suitable Python installation, it's necessary to install the Python dependencies and point reticulate at your Python installation. One way to do this is running the included **init_python_venv.sh** shell script, e.g.:

```
source ./init_python_venv.sh
```

Alternatively you can individually run the commands in the above file if you are not running in a bash compatible shell.

### conda

Alternatively, if you do not want to use `pyenv`, you can can ignore the [Python dependencies](#python-dependencies) section above and create a conda environment.  [Get anaconda]([anaconda](https://www.anaconda.com/products/individual))  Once installed on your machine:

```
conda create -n synapse python=3.8
conda activate synapse
pip install synapseclient
```

Make sure you add in your `server.R`:

```
reticulate::use_condaenv("synapse")
```


### Authentication (OAuth)

In the reticulate variation of the application login is via a Synapse object instantiated within the scope of the Shiny session. This contrasts with the **synapser** version of application, where the shared global Synapse client necessitates other workarounds to avoiding shared login state.  This also utilizes a Synapse OAuth client (code motivated by [ShinyOAuthExample](https://github.com/brucehoff/ShinyOAuthExample) and [app.R](https://gist.github.com/jcheng5/44bd750764713b5a1df7d9daf5538aea).  Each application is required to have its own OAuth client as these clients cannot be shared between one another.  View instructions [here](https://docs.synapse.org/articles/using_synapse_as_an_oauth_server.html) to learn how to request a client.  Once you obtain the `client_id` and `client_secret` make sure to add it to the configuration file.

```
cp example_config.yaml config.yaml
# Edit config.yaml
chmod 400 config.yaml
```
