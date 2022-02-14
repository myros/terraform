FROM gcr.io/config-validator/terraform-validator

WORKDIR /tmp

RUN rm -rf /usr/local/bin/terraform
RUN wget https://releases.hashicorp.com/terraform/1.1.5/terraform_1.1.5_linux_amd64.zip && unzip terraform_1.1.5_linux_amd64.zip -d /usr/local/bin

RUN curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash

RUN apt install -y software-properties-common jq python3-pip

RUN pip3 install checkov terrascan jq

ENTRYPOINT ["/terraform-validator/bin/terraform-validator"]