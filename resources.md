---
layout: page
title: resources
permalink: /resources/
---

## Tools 
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


#### Helpful links and articles to get you started with data analysis and visualization   
<br>

#### Articles
- <a href = "http://www.bloomberg.com/graphics/2015-paul-ford-what-is-code/" target="_blank">Ford, P. (2015). "What is code?" Bloomberg.</a> 
- <a href = "http://www.vikparuchuri.com/blog/how-learning-to-code-kept-me-sane/" target="_blank">Paruchuri, V. (2014). "How learning to code kept me sane when I was a diplomat." Vik's Blog.</a> 
- <a href = "http://www.aeaweb.org/articles.php?doi=10.1257/jep.28.1.209" target="_blank">Schwabish, J. (2014). “An Economists’ Guide to Visualizing Data,” Journal of Economic Perspectives, Vol. 28, No. 4.</a> 

#### Blogs

- <a href = "http://stephanieevergreen.com/category/blog/" target="_blank">Evergreen Data</a> 
- <a href = "http://flowingdata.com/" target="_blank">FlowingData</a> 
- <a href = "http://policyviz.com/" target="_blank">PolicyViz</a> 
- <a href = "storytellingwithdata.com" target="_blank">Story Telling With Data</a> 
- <a href = "http://www.visualisingdata.com/" target="_blank">Visualizing Data</a> 


#### Help

- <a href = "http://www.stata.com/support/faqs/graphics/gph/stata-graphs/" target="_blank">Stata Graphs</a> 
- <a href = "http://www.statalist.org/" target="_blank">StataList</a> 
- <a href = "http://www.ats.ucla.edu/stat/stata/" target="_blank">UCLA Stata Resources</a> 


#### Podcasts

- <a href = "http://datastori.es/" target="_blank">Data Stories</a> 
- <a href = "https://itunes.apple.com/us/podcast/the-policyviz-podcast/id982966091?mt=2" target="_blank">Policyviz Podcast</a> 

#### Web-based Tools

- <a href = "https://color.adobe.com/" target="_blank">Adobe Color</a> 
- <a href = "http://colorbrewer2.org/" target="_blank">ColorBrewer</a> 
- <a href = "https://www.databasic.io/en/" target="_blank">DataBasic</a> 

