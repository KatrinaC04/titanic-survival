FROM r-base:4.4.2

WORKDIR /app

COPY src/r/install_packages.R ./install_packages.R

RUN Rscript install_packages.R

COPY src/r/titanic_model.R ./titanic_model.R

CMD ["Rscript", "titanic_model.R"]

