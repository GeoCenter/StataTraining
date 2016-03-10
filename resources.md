---
layout: page
title: resources
permalink: /resources/
---

#### Helpful links and articles to get you started with data analysis and visualization   
<br>

{% for resource in site.portfolio %}

{% if resource.redirect %}
<div class="icon">
    <div class="thumbnailicon">
        <a href="{{ resource.redirect }}" target="_blank">
        {% if resource.img %}
        <img class="thumbnailicon" src="{{ project.img }}"/>
        {% else %}
        <div class="thumbnailicon blankbox"></div>
        {% endif %}    
        <span>
            <h5>{{ resource.title }}</h5>
            <br/>
            <h6>{{ resource.description }}</h6>
        </span>
        </a>
    </div>
</div>
{% else %}

<div class="icon">
    <div class="thumbnailicon">
        <a href="{{ site.baseurl }}{{ resource.url }}">
        {% if resource.img %}
        <img class="thumbnailicon" src="{{ resource.img }}"/>
        {% else %}
        <div class="thumbnailicon blankbox"></div>
        {% endif %}    
        <span>
            <h5>{{ resource.title }}</h5>
            <br/>
            <h6>{{ resource.description }}</h6>
        </span>
        </a>
    </div>
</div>

{% endif %}

{% endfor %}




