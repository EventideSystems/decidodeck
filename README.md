# Decidodeck

[![License: AGPL v3](https://img.shields.io/badge/License-AGPL_v3-blue.svg)](https://www.gnu.org/licenses/agpl-3.0)
![check](https://github.com/EventideSystems/decidodeck/actions/workflows/check.yml/badge.svg)
[![Ruby Style Guide](https://img.shields.io/badge/code_style-rubocop-brightgreen.svg)](https://github.com/rubocop/rubocop)
[![Ruby Style Guide](https://img.shields.io/badge/code_style-community-brightgreen.svg)](https://rubystyle.guide)


**Adaptive strategy infrastructure for living Theories of Change**

> NOTE: We are in the early stages of developing this new platform, merging the original
> Tool for Systemic Change with the experimental [Decidodeck prototype](https://github.com/EventideSystems/decidodeck-prototype).
>
> Please consider this README and associated documentation as aspirational - any feedback on what we are trying to achieve is highly appreciated. 

## Overview

Decidodeck is an open-source platform for adaptive change management. It helps teams design, evolve, and reflect on complex Theories of Change by blending outcome-mapping with  tools that surface tensions, track shifts, and reveal hidden connections.

Drawing from business, software development, manufacturing, and systems thinking, it reimagines familiar methods — _e.g._ logic models and agile workflows — as tools for shared meaning-making and strategic attunement.

Decidodeck helps teams visualize connections between stakeholders, sense misalignment, and reshape strategy as the terrain unfolds. It promotes a shared understanding of complex problems and the strategies needed to address them.

The Decidodeck platform can be customized to support a wide range of systemic change initiatives. It forms the basis of these online applications, each expressing different facets of Decidodeck's architecture: 

* [FreeSDG.org](https://freesdg.org) - a simplified module for tracking initiatives against the UN Sustainable Development Goals.
* [Obsek.io](https://obsek.io) - management of business workflows through customizable, checklist-driven processes.
* [ToolForSystemicChange.com](https://toolforsystemicchange.com) - evidence-based planning and collaborative action on complex societal problems.

Additionally, a default implementation of the platform can be found at [Decidodeck.com](https://decidodeck.com). **NB:** All implementations share a common infrastructure, allowing users to "mix and match" services across Decidodeck themes - combining SDG tracking, compliance management, and strategic modeling as needed.

Decidodeck is a rewrite of [Wicked Lab's](https://web.archive.org/web/20240329200630/https://www.wickedlab.co/) **Tool for Systemic Change**. It enhances the original Tool, improving its performance and accessiblity.

Decidodeck is written using [Ruby on Rails](https://rubyonrails.org/) and is available under the [AGPL-3.0](https://www.gnu.org/licenses/agpl-3.0.en.html) open source license.

## Who is Decidodeck For?

- Strategy and program evaluation professionals working in complex systems  
- Funders and grantees seeking participatory evaluation methods  
- Social justice orgs rethinking traditional planning formats  
- Cross-disciplinary teams who want a shared, reflective space for change modeling

## ☕ Support Decidodeck

If Decidodeck resonates with your work, consider [buying us a coffee](https://buymeacoffee.com/eventidesystems) to help keep the lights on and the ideas flowing. Your support helps us build thoughtful tools for systemic change.

## Philosophy

Decidodeck is more than a planning tool - it's built on the understanding that change is complex and often messy. It recognizes that strategy involves emotion, that contradictions can spark new insights, and that learning rarely follows a straight path.

Instead of chasing clarity for its own sake, Decidodeck holds space for complexity and desire. It helps teams map not only what they aim to do - but also what they're not willing to betray in the process.

This is strategy with care. With contradiction. With ghosts. [Read the full document →](/doc/PHILOSOPHY.md)

## Current Features

### Model Initiatives and Track Progress 

Use Decidodeck to define the objectives behind your strategic efforts and record the actions you take toward achieving them.

Start with pre-built data-collection models - like the United Nations' Sustainable Development Goals - or customize them to fit your needs. Build your own models from scratch to reflect the unique contours of your work.

[Example screenshot →](app/assets/images/data_entry.png)

### Measure Impact

Get a clear overview of your related initiatives with Decidodeck. Compare progress across projects, spot gaps in effort, and stay aligned as your strategy evolves.

[Example screenshot →](app/assets/images/screenshot.png)

### Map Stakeholder Influence

Use Decidodeck to visualize how stakeholders connect across your initiatives. Identify who holds the most influence within your ecosystem, and understand how each party shapes the outcomes of your tracked projects.

[Example screenshot →](app/assets/images/graph.png)

## Planned Features

### Shared Workspaces

Work collaboratively in a common space where your team can build strategy, stay aligned on goals, and make decisions collaboratively as things evolve.

### Enhanced Stakeholder Management

Identify and understand the people and organizations that matter to your strategy, their connections, influences, potential conflicts and opportunities for collaboration. 

### Outcome Mapping + Drift Tracking

Track how your intended outcomes evolve over time - spot where things stay aligned, and where they begin to shift, stretch, or stray.

### Tool and Process Library  

Store, remix, and document frameworks used across your organization. Choose the right tools for the moment, adapt as needed, and keep evolving practice within your team.

For more details, refer to our [design documentation →](/doc/DESIGN.md)


## Acknowledgments

We're grateful to Wicked Lab for developing the original Tool for Systemic Change and for agreeing to release the code as open source.

We'd also like to thank [AppSignal](https://www.appsignal.com/) for providing monitoring and error tracking services.

And naturally we appreciate our users, without whose support and feedback this project would not exist.    

So, thank you to everyone!

## License & Attribution

Copyright © 2023 Wicked Lab

Copyright © 2025 Eventide Systems Pty Ltd

This software is licensed under the GNU Affero General Public License, version 3 ("AGPL-3.0"). See the [LICENSE](LICENSE.md) file for details.  

NB the `db/data_models` directory contains seed data models that are copyright their respective owners.

This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for more details.

If you modify this program, or any covered work, by linking or combining it with Decidodeck, containing parts covered by the terms of the Affero GPL 3 license, the licensors of this program grant you additional permission to convey the resulting work. Corresponding Source for a non-source form of such a combination shall include the source code for the parts of the Tool for Systemic Change that are used as well as that of the covered work.

Attribution Notice:

- If you modify the software, you must place prominent notices in the modified files stating that you changed the files and the date of any change.

- If you distribute the software or any derivative works in source code form, you must retain the original copyright notices, the above license notice, and provide clear attribution to Emily Humphreys and Eventide Systems Pty Ltd.

- If you distribute the software or any derivative works in binary form, you must, at a minimum, reproduce the above copyright notice, this list of conditions, and the following disclaimer in the documentation and/or other materials provided with the distribution.

For any questions regarding the use of this software, please contact hello@toolforsystemicchange.com or raise a ticket in the project's [issue tracker on Github](https://github.com/EventideSystems/tool_for_systemic_change/issues).


## Get Involved

Decidodeck welcomes contributors from design, strategy, and open-source backgrounds. All source code and design documentation are available for adaptation and reuse (subject to the terms of the [Afferro GPL License](LICENSE)).

Before contributing, please familiarize yourself with the project's [License](LICENSE) and [Code of Conduct](/doc/CODE_OF_CONDUCT.md).

You can view Decidodeck's latest development progress on the [Github project board](https://github.com/orgs/EventideSystems/projects/1).
