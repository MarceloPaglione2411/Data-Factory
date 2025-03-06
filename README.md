# Data-Factory
## Pipeline para copia de dados entre Containers Blob.

### Este projeto tem finalidade de migrar informações de um Container Blob de origem  para outro Container Blob de destino.

1- Criado a infra-Estrutura do Data Factory com os links de conexão para os Containers Blob.

2- Criado os data Set Origem - Destino. Apontando para o \path\dados

3- Criado Pipeline para para agendamento da copia BlobSource ---> BlobDestino com intervalo 120 Segundos.

4- Criado uma Trigger para o disparo do job de copia em um horário determinado.

![imagem do projeto](\storage\arquitetura.jpg)
