##data block
data "azurerm_resource_group" "data-storage-marcelo" {
    name = "storage-marcelo"
}

data "azurerm_storage_account" "storage1" {
  name                = "stoorigemmarcelo"
  resource_group_name = "storage-marcelo"
}

data "azurerm_storage_container" "container1" {
  name               = "dados"
  storage_account_id = data.azurerm_storage_account.storage1.id
}


data "azurerm_storage_account" "storage2" {
  name                = "stodestinomarcelodestino"
  resource_group_name = "storage-marcelo"
}

data "azurerm_storage_container" "container2" {
  name               = "dados"
  storage_account_id = data.azurerm_storage_account.storage2.id
}


resource "azurerm_data_factory" "mod-data-factory" {
  name                = "adflink-${random_id.suffix.hex}"
  location            = data.azurerm_resource_group.data-storage-marcelo.location
  resource_group_name = data.azurerm_resource_group.data-storage-marcelo.name
}

resource "random_id" "suffix" {
  byte_length = 4
}

# Linked Services (Origem e Destino)
resource "azurerm_data_factory_linked_service_azure_blob_storage" "mod-linked-origem" {
  name              = "data_link_origem"
  data_factory_id   = azurerm_data_factory.mod-data-factory.id
  connection_string = data.azurerm_storage_account.storage1.primary_connection_string
}

resource "azurerm_data_factory_linked_service_azure_blob_storage" "mod-linked-destino" {
  name              = "data_link_destino"
  data_factory_id   = azurerm_data_factory.mod-data-factory.id
  connection_string = data.azurerm_storage_account.storage2.primary_connection_string
}

# Datasets (Origem e Destino)
resource "azurerm_data_factory_dataset_azure_blob" "mod-dataset-origem" {
  name                = "data_set_origem"
  data_factory_id     = azurerm_data_factory.mod-data-factory.id
  linked_service_name = azurerm_data_factory_linked_service_azure_blob_storage.mod-linked-origem.name

  path     = "dados"
  #filename = ""
}

resource "azurerm_data_factory_dataset_azure_blob" "mod-dataset-destino" {
  name                = "data_set_destino"
  data_factory_id     = azurerm_data_factory.mod-data-factory.id
  linked_service_name = azurerm_data_factory_linked_service_azure_blob_storage.mod-linked-destino.name

  path     = "dados"
  #filename = ""
}


# Pipeline
resource "azurerm_data_factory_pipeline" "mod-pipeline" {
  name              = "PipelineCopyBlob"
  data_factory_id   = azurerm_data_factory.mod-data-factory.id

  depends_on = [ azurerm_data_factory_dataset_azure_blob.mod-dataset-origem, azurerm_data_factory_dataset_azure_blob.mod-dataset-destino  ]

activities_json = <<JSON
[
  {
    "name": "CopyFolderActivity",
    "type": "Copy",
    "dependsOn": [],
    "policy": {
      "timeout": "7.00:00:00",
      "retry": 0,
      "retryIntervalInSeconds": 30,
      "secureOutput": false,
      "secureInput": false
    },
    "typeProperties": {
      "source": {
        "type": "BlobSource",
        "recursive": true
      },
      "sink": {
        "type": "BlobSink",
        "copyBehavior": "PreserveHierarchy"
      },
      "enableStaging": false
    },
    "inputs": [
      {
        "referenceName": "data_set_origem",
        "type": "DatasetReference"
      }
    ],
    "outputs": [
      {
        "referenceName": "data_set_destino",
        "type": "DatasetReference"
      }
    ]
  },
  {
    "name": "WaitActivity",
    "type": "Wait",
    "dependsOn": [
      {
        "activity": "CopyFolderActivity",
        "dependencyConditions": ["Succeeded"]
      }
    ],
    "typeProperties": {
      "waitTimeInSeconds": 120 
    }
  },
  {
    "name": "DeleteActivity",
    "type": "Delete",
    "dependsOn": [
      {
        "activity": "WaitActivity",
        "dependencyConditions": ["Succeeded"]
      }
    ],
    "typeProperties": {
      "recursive": true,
      "dataset": {
        "referenceName": "data_set_origem",
        "type": "DatasetReference"
      }
    }
  }
]
JSON

}

resource "azurerm_data_factory_trigger_schedule" "mod-trigger-schedule2" {
  name            = "trigger4"
  data_factory_id = azurerm_data_factory.mod-data-factory.id
  pipeline_name   = azurerm_data_factory_pipeline.mod-pipeline.name

  interval  = 1
  frequency = "Day"

  start_time = "2025-03-01T12:32:00-03:00"

  
}
