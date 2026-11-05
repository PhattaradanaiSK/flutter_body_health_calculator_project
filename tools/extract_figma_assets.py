from pathlib import Path
from PIL import Image
import numpy as np

ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / "docs" / "figma_reference"
OUT = ROOT / "assets" / "images"
BODY = np.array([254, 247, 255], dtype=np.int32)

# Source screenshot and tight crop rectangle (left, top, right, bottom).
CROPS = {
    "app_logo.png": ("home_about.png", (455, 1185, 835, 1565)),
    "bmr.png": ("bmr.png", (405, 600, 885, 1105)),
    "bmi.png": ("bmi.png", (108, 78, 235, 202)),
    "sau_logo.png": ("home_about.png", (542, 2205, 748, 2410)),
}

OUT.mkdir(parents=True, exist_ok=True)
for target, (source, box) in CROPS.items():
    im = Image.open(SOURCE / source).convert("RGBA").crop(box)
    px = np.asarray(im).copy()
    rgb = px[..., :3].astype(np.int32)
    # Convert the exact/light near-uniform #FEF7FF page background to alpha.
    # A soft transition at the antialiased edge avoids a pale fringe.
    distance = np.sqrt(np.sum((rgb - BODY) ** 2, axis=2))
    alpha = np.clip((distance - 7.0) * (255.0 / 18.0), 0, 255).astype(np.uint8)
    alpha[distance <= 7.0] = 0
    px[..., 3] = np.minimum(px[..., 3], alpha)
    Image.fromarray(px, "RGBA").save(OUT / target, optimize=True)
