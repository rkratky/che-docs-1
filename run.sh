docker run -ti -p 4000:4000 -v $(pwd):/che-docs eivantsov/jekyll-docs sh -c "cd /che-docs && jekyll serve"