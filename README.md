# Create SLM - Solar Panel Recommendation System

A specialized Small Language Model (SLM) for providing solar panel installation recommendations in Spanish, built using MLX and LoRA fine-tuning on Mistral-7B-Instruct-v0.2.

## Overview

This project creates a domain-specific language model that provides personalized solar panel installation recommendations based on house characteristics and location in Spain. The model is trained to recommend specific solar panel brands, quantities, and power configurations for different types of homes.

## Features

- **Specialized Domain Knowledge**: Trained specifically on solar panel installation data
- **Spanish Language Support**: Native Spanish language understanding and responses
- **Location-Aware Recommendations**: Considers geographical factors (Madrid, Sevilla, Girona, etc.)
- **House Type Analysis**: Handles different property types (pareada, unifamiliar, chalet, etc.)
- **Technical Specifications**: Provides detailed panel counts, wattage, and inverter recommendations

## Model Architecture

- **Base Model**: Mistral-7B-Instruct-v0.2
- **Fine-tuning Method**: LoRA (Low-Rank Adaptation)
- **Framework**: MLX (Apple's ML framework for efficient training on Apple Silicon)

## Quick Start

### Prerequisites

- Python 3.8+
- Apple Silicon Mac (for MLX optimization)
- Hugging Face account and CLI access
- Create a new repository on Hugging Face Hub
- Create a new API key for Hugging Face Hub with write permissions

### Installation

1. **Set up the environment**:
   ```bash
   ./1-create-environment.sh
   ```
   This script will:
   - Create a Python virtual environment
   - Install MLX-LM package
   - Set up Hugging Face CLI authentication
   - Download the base Mistral-7B-Instruct-v0.2 model

2. **Train the model**:
   ```bash
   ./2-training-script.sh
   ```
   This will fine-tune the model using LoRA with the solar panel dataset.

3. **Fuse the adapter to the model**:
   ```bash
   ./3-fuse-fine-tuning-to-model.sh
   ```
   This will merge the LoRA adapter weights with the base model for deployment.

4. **Test the model**:
   ```bash
   ./4-test-slm.sh
   ```
   This will run a test prompt to verify the model is working correctly.

### Manual Setup

If you prefer to set up manually:

```bash
# Create and activate virtual environment
python -m venv .venv
source .venv/bin/activate

# Install dependencies
pip install mlx-lm

# Authenticate with Hugging Face
huggingface-cli login

# Download base model (note: You need to accept the terms of service in the Hugging Face website, in the model)
huggingface-cli download mistralai/Mistral-7B-Instruct-v0.2

# Run training
python -m mlx_lm.lora \
    --model mistralai/Mistral-7B-Instruct-v0.2 \
    --train \
    --data ./training-data \
    --adapter-path ./adapter \
    --iters 200

# Fuse adapter with base model
python -m mlx_lm fuse \
    --model mistralai/Mistral-7B-Instruct-v0.2 \
    --adapter-path ./adapter \
    --save-path ./mistral_solar_fuse_1

# Test the model
python -m mlx_lm.generate --model ./mistral_solar_fuse_1 --prompt "Tengo una masia en Catalunya de 380m2, ¿qué me recomiendas? Nota: no quiero inversor Huawei."
```

## Project Structure

```
create-slm/
├── README.md                         # This file
├── 1-create-environment.sh           # Environment setup script
├── 2-training-script.sh              # Training execution script
├── 3-fuse-fine-tuning-to-model.sh    # Fuse adapter with base model
├── 4-test-slm.sh                     # Test the trained model
├── .venv/                            # Python virtual environment
├── training-data/                    # Training datasets
│   ├── train.jsonl                  # Training data in JSONL format
│   └── valid.jsonl                  # Validation data
├── adapter/                          # LoRA adapter weights
│   └── adapter_config.json          # Adapter configuration
└── mistral_solar_fuse_1/             # Fused model (created after step 3)
```

## Training Data Format

The training data is in JSONL format with conversation structure:

```json
{
  "messages": [
    {
      "role": "user",
      "content": "Tengo una casa pareada en Madrid de 160m2, ¿qué instalación solar me recomendáis?"
    },
    {
      "role": "assistant",
      "content": "Para una casa pareada en Madrid, te recomendamos una instalación de 14 paneles solares Hyundai HG de 430W Full Black..."
    }
  ]
}
```

## Model Capabilities

The trained model can provide recommendations for:

- **Panel Brands**: Hyundai HG, TONGWEI Solar
- **Panel Types**: Full Black panels (430W, 435W)
- **Inverters**: Huawei SUN2000, Fronius Primo
- **House Types**: Pareada, unifamiliar, chalet, casa de campo
- **Size Considerations**: Based on square meters and house configuration
- **Location Factors**: Different Spanish cities and regions

## Usage Examples

After training and fusing, you can use the model to get solar panel recommendations:

**Test Input**: "Tengo una masia en Catalunya de 380m2, ¿qué me recomiendas? Nota: no quiero inversor Huawei."

**Expected Behavior**: The model should provide a recommendation considering the large size (380m²), the Catalan location, and specifically avoid Huawei inverters per the user's request.

**Training Example**:
- **Input**: "Tengo un chalet grande de 240m2 en una sola planta. Es una casa 4 vientos. ¿Qué me sugerís?"
- **Expected Output**: "En una casa de 240m², te recomendamos una instalación de 22 paneles solares TONGWEI Solar de 435W FULLBLACK. Con esto, obtendrías una potencia total de 9.57 kW, ideal para un alto consumo. El sistema funcionaría con un inversor Huawei SUN2000."

## Technical Details

### Training Parameters

- **Iterations**: 200
- **Method**: LoRA (Low-Rank Adaptation)
- **Base Model**: Mistral-7B-Instruct-v0.2
- **Data Format**: Conversational JSONL
- **Deployment**: Fused adapter + base model for standalone inference

### Model Deployment Process

1. **Training**: LoRA adapter is trained on solar panel data
2. **Fusing**: Adapter weights are merged with the base model
3. **Testing**: Model is validated with domain-specific prompts
4. **Result**: Standalone model ready for deployment

### Hardware Requirements

- **Recommended**: Apple Silicon Mac (M1/M2/M3) for optimal MLX performance
- **Memory**: 16GB+ RAM recommended
- **Storage**: ~20GB for model and training data

## Contributing

To contribute to this project:

1. Add more training examples to `training-data/train.jsonl`
2. Include validation examples in `training-data/valid.jsonl`
3. Follow the existing conversation format
4. Ensure Spanish language consistency
5. Include diverse house types and locations

## License

This project is for educational and research purposes. Please respect the licenses of the underlying models and datasets used.

## Acknowledgments

- **Mistral AI** for the base Mistral-7B-Instruct-v0.2 model
- **Apple** for the MLX framework
- **Hugging Face** for model hosting and tools
- Solar panel manufacturers (Hyundai, TONGWEI) and inverter companies (Huawei, Fronius) mentioned in the training data

---

*This SLM demonstrates the power of domain-specific fine-tuning for creating specialized AI assistants in the renewable energy sector.*
