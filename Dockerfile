FROM httpd:2.4
COPY ./code/ /usr/local/apache2/htdocs/destinations/code/
RUN chmod +x /usr/local/apache2/htdocs/destinations/code/*.pl
COPY ./example/ /usr/local/apache2/htdocs/destinations/example/
RUN apt-get update && apt-get install -y libapache2-mod-perl2 \ 
    libcgi-pm-perl libdata-compare-perl libjson-xs-perl perl && \
    apt-get clean

# Enable CGI module in Apache
RUN sed -i 's/#LoadModule cgid_module/LoadModule cgid_module/' /usr/local/apache2/conf/httpd.conf

# Configure Apache to allow CGI execution
RUN echo '<Directory "/usr/local/apache2/htdocs/destinations/code">' >> /usr/local/apache2/conf/httpd.conf && \
    echo '    Options +ExecCGI' >> /usr/local/apache2/conf/httpd.conf && \
    echo '    AddHandler cgi-script .cgi .pl' >> /usr/local/apache2/conf/httpd.conf && \
    echo '    Require all granted' >> /usr/local/apache2/conf/httpd.conf && \
    echo '</Directory>' >> /usr/local/apache2/conf/httpd.conf

# Disable indexing, as it is a security risk
RUN sed -i 's/Options Indexes FollowSymLinks/Options FollowSymLinks/' /usr/local/apache2/conf/httpd.conf

# Make sure index.htm is displayed when no file is specified
RUN echo 'DirectoryIndex index.htm' >> /usr/local/apache2/conf/httpd.conf