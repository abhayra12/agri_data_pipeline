# Agricultural Data Pipeline - Build System

This document explains how to use the unified build script for managing the Agricultural Data Pipeline.

## Overview

The Agricultural Data Pipeline processes agricultural data through several stages:

1. **Infrastructure Setup**: Sets up GCS bucket and BigQuery dataset using Terraform
2. **Data Generation & Streaming**: Generates sample agricultural data and streams it to GCS via Kafka
3. **Batch Processing**: Processes raw data using Spark and exports it to BigQuery
4. **Business Transformations**: Applies business logic transformations using dbt on the data in BigQuery

## Build Script Architecture

The build system has been designed with a modular architecture:

1. **Main Build Script** (`build.sh`): Orchestrates the overall build process
2. **Module Scripts** (in `scripts/` directory):
   - `scripts/streaming/functions.sh`: Kafka and streaming pipeline functions
   - `scripts/spark/functions.sh`: Spark and batch processing functions
   - `scripts/batch/functions.sh`: Batch pipeline and GCS connector functions
   - `scripts/dbt/functions.sh`: DBT transformation functions
3. **Module Loader** (`scripts/main.sh`): Loads all module scripts and provides common utilities

All scripts include robust error handling and validation to ensure proper execution and easy troubleshooting.

## Build Script Usage

### Basic Usage

To rebuild the entire pipeline from scratch:

```bash
./build.sh
```

This will:
1. Destroy existing infrastructure
2. Clean Docker resources (volumes, networks, images)
3. Reinitialize infrastructure with Terraform
4. Start Kafka and Spark services
5. Run the streaming pipeline (data generation + Kafka consumption)
6. Run the batch pipeline with Spark
7. Execute dbt business transformations

### Command-line Options

The build script supports several command-line options:

```bash
./build.sh [OPTION]
```

Available options:

| Option | Description |
|--------|-------------|
| `--help` | Display help message |
| `--rebuild` | Rebuild the entire pipeline (default action) |
| `--clean-only` | Only clean resources without rebuilding |
| `--status` | Display the status of all pipeline components |
| `--streaming-only` | Only start the streaming pipeline |
| `--batch-only` | Only run the batch pipeline |
| `--dbt-only` | Only run the dbt transformations |
| `--gcs-status` | Check data in GCS bucket |

### Examples

Check current status of the pipeline:
```bash
./build.sh --status
```

Check GCS bucket for data:
```bash
./build.sh --gcs-status
```

Clean all resources without rebuilding:
```bash
./build.sh --clean-only
```

Run only the streaming pipeline (requires Kafka to be running):
```bash
./build.sh --streaming-only
```

Run only the batch pipeline (requires Spark to be running):
```bash
./build.sh --batch-only
```

Run only the dbt transformations:
```bash
./build.sh --dbt-only
```

## Prerequisites

The build script requires:

- Docker and Docker Compose
- Terraform
- Python 3
- GCP credentials (gcp-creds.json in the project root)
- Environment variables (.env file in the project root)

## Extending the Build System

To add new functionality to the build system:

1. Add new functions to the appropriate module in `scripts/` directory
2. Update `scripts/main.sh` if adding new module files
3. Extend the `build.sh` script to use the new functions

## Troubleshooting

If any component fails:

1. Check the logs for the specific component:
   ```bash
   docker logs agri_data_consumer  # For streaming consumer
   ```

2. Try running individual components:
   ```bash
   ./build.sh --clean-only  # Clean everything
   ./build.sh --streaming-only  # Run just the streaming component
   ```

3. Verify infrastructure status:
   ```bash
   ./build.sh --status
   ```

4. Check for data in GCS:
   ```bash
   ./build.sh --gcs-status
   ``` 