#!/bin/bash
# echo "Aguardando o SQL Server iniciar..."
# sleep 10

# echo "Iniciando execução dos scripts SQL..."
# /opt/mssql-tools/bin/sqlcmd -S sqlserver -U sa -P "YourStrong@Passw0rd" -d master -i /scripts/sqlserver-schema.sql

#!/bin/bash

# echo "Aguardando o SQL Server estar pronto..."
# sleep 20

# echo "Criando o banco de dados SimuladorCredito..."
# /opt/mssql-tools/bin/sqlcmd -S sqlserver -U sa -P "YourStrong@Passw0rd" -Q "CREATE DATABASE SimuladorCredito"

# echo "Executando scripts de criação de tabelas..."
# /opt/mssql-tools/bin/sqlcmd -S sqlserver -U sa -P "YourStrong@Passw0rd" -d SimuladorCredito -i /scripts/sqlserver-schema.sql


#!/bin/bash

echo "Aguardando o SQL Server aceitar conexões..."

# Loop até o SQL Server responder com sucesso
for i in {1..30}; do
  /opt/mssql-tools/bin/sqlcmd -S sqlserver -U sa -P "YourStrong@Passw0rd" -Q "SELECT 1" &> /dev/null
  if [ $? -eq 0 ]; then
    echo "SQL Server está pronto para conexões."
    break
  fi
  echo "Aguardando... ($i)"
  sleep 2
done

echo "Executando scripts SQL..."
/opt/mssql-tools/bin/sqlcmd -S sqlserver -U sa -P "YourStrong@Passw0rd" -d master -i /scripts/sqlserver-schema.sql