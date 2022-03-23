# Secure your Rails Application with Contrast Security

This repository is an example of how to install the Contrast Security Agent in 
a Ruby on Rails application.

The agent is installed as a Gem and runs alongside your application code and 
serves as an all-encompassing static code scanner, SCA tool, IAST agent and 
runtime self-protection tool. For more information, check out their 
[website][Contrast Home] and [Community Edition][Contrast community].

* Original vulnerable application source code taken from:
[OWASP/railsgoat][railsgoat]
* Only changes made are to instrument the application with 
[Contrast Security][Contrast Home]


### Building a CICD pipeline
This repo features some GitHub actions for building the Docker image with the 
Contrast agent installed, and running tests against this image in GitHub actions
before pushing the built images to an ECR and orchestrating an ECS service to 
run the container in.


## Instrument a Rails application with Contrast Security
A step-by-step guide for implementing the Agent in this specific application, 
instrumentation requirements vary per technology stack. Please refer to the 
official [Contrast Security Documentation][Contrast Docs Home] for more 
information.

### 1. Install the Agent
The agent is installed as a Ruby Gem and can be found 
[here](https://rubygems.org/gems/contrast-agent/versions/3.8.4). Install it 
simply by adding the required Gem to your Gemfile and rebuilding the container. 

```bash
# Adding the contrast Agent
gem 'contrast-agent'
```

If you are installing the agent in a running application or outside of a 
container, you will need to run `bundle install` and may need to restart the 
rails server.


### 2. Provision middleware components
Unlike with the [Python project][vulnerable-python-contrast], we don't require 
any additional configuration to enable middleware in Rails. Other Ruby 
frameworks may require middleware configuration, however, so you should refer 
to the [documentation][Configure middleware] 


### 3. Configure the Contrast Agent
Using the [YAML template][Configure agent] provided, or by downloading a YAML 
template from the Contrast web portal, we can configure the agent:

`contrast_security.yml`:
```yaml
api:
  url: https://eval.contrastsecurity.com/Contrast
  api_key: XXX
  service_key: XXX
  user_name: XXX@XXX

application:
    name: VulnerableApp-Rails-Demo
    code: demo-2
```

> :warning: **Do not commit API credentials to your GitHub repo!**: A template 
`contrast_security.yml.dist` file has been provided for your convenience. Copy
this file to `contrast_security.yml` and add your API details. This file is 
already added to `.gitignore` - ensure you don't accidentally remove this or
add it anyway.

The Ruby Agent looks for configuration in some default places. This can be 
either `/opt/contrast/contrast_security.yaml`, or along with other configuration
files in `config/contrast_security.yaml`, which is were I have placed it.


### 4. Run your application
Now run your application and browse around the pages as you normally would. If 
everything worked, then when you next go to your Contrast Security dashboard 
you'll see details for the new application and any security issues that have
been detected.


[Contrast Home]: https://www.contrastsecurity.com/
[Contrast community]: https://www.contrastsecurity.com/en-gb/contrast-community-edition
[Contrast Docs Home]: https://docs.contrastsecurity.com/index.html?lang=en

[Python agent]: https://docs.contrastsecurity.com/en/python.html
[Configure middleware]: https://docs.contrastsecurity.com/en/ruby-frameworks.html#configure-with-rails
[Configure agent]: https://docs.contrastsecurity.com/en/ruby-configuration.html
[railsgoat]: https://github.com/OWASP/railsgoat

[vulnerable-python-contrast]:https://github.com/mowsec/vulnerable-python-contrast/blob/main/README.md
