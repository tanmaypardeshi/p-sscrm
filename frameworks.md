---
layout: page
title: "Standards & Frameworks"
permalink: /frameworks/
description: "The government and industry standards P-SSCRM was built from. Every control maps to one or more of them."
---

P-SSCRM was assembled by analysing and unifying the standards and frameworks
below. Every P-SSCRM control cites one or more of them, so aligning with
P-SSCRM keeps you aligned with these sources. For the reverse view — which
controls cite a given standard — see
[the framework page]({{ "/framework/" | relative_url }}#standards).

{% assign fw_order = "eo,800-161,ssdf,ssdf-ai,self-attestation,slsa,bsimm,samm,cncf-ssc,s2c2f,osps,ossf-scorecard,owasp-scvs" | split: "," %}
<ul class="framework-index">
  {% for key in fw_order %}
    {% assign fw = site.data.frameworks[key] %}
    {% if fw %}
      <li>
        <h2>{% if fw.url %}<a href="{{ fw.url }}" target="_blank" rel="noopener">{{ fw.name }}</a>{% else %}{{ fw.name }}{% endif %}</h2>
        <p>{{ fw.full_name }}</p>
      </li>
    {% endif %}
  {% endfor %}
</ul>
