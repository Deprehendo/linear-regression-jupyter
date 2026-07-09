#!/usr/bin/env python3
"""Simple linear regression from CSV with scatter plot and regression line output."""

from __future__ import annotations

import argparse
import sys
from pathlib import Path

import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
from sklearn.linear_model import LinearRegression
from sklearn.metrics import mean_absolute_error, mean_squared_error, r2_score

OUTPUT_PNG = Path(__file__).resolve().parent / "regression_python.png"


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Fit a linear regression model and save a scatter plot with fitted line."
    )
    parser.add_argument("--filepath", required=True, help="Path to the input CSV file")
    parser.add_argument("--x-col", dest="x_col", required=True, help="Predictor column name")
    parser.add_argument("--y-col", dest="y_col", required=True, help="Response column name")
    return parser.parse_args()


def validate_inputs(args: argparse.Namespace) -> pd.DataFrame:
    path = Path(args.filepath)
    if not path.is_file():
        raise ValueError(f"File not found: {path}")

    df = pd.read_csv(path)
    for col in (args.x_col, args.y_col):
        if col not in df.columns:
            raise ValueError(f"Column not found in CSV: {col}")
        if not pd.api.types.is_numeric_dtype(df[col]):
            df[col] = pd.to_numeric(df[col], errors="coerce")
            if df[col].isna().any():
                raise ValueError(f"Column must be numeric: {col}")

    return df


def main() -> int:
    args = parse_args()

    try:
        df = validate_inputs(args)
    except ValueError as exc:
        print(f"Error: {exc}", file=sys.stderr)
        return 1

    print(f"Rows: {len(df)}, Columns: {len(df.columns)}")
    print("\nHead:")
    print(df.head())
    print("\nSummary:")
    print(df.describe())

    X = df[[args.x_col]]
    y = df[args.y_col]

    model = LinearRegression()
    model.fit(X, y)

    intercept = model.intercept_
    slope = model.coef_[0]
    print(f"\nIntercept (beta_0): {intercept:,.2f}")
    print(f"Slope (beta_1):     {slope:,.2f}")

    x_line = pd.DataFrame(
        {args.x_col: np.linspace(X[args.x_col].min(), X[args.x_col].max(), 100)}
    )
    y_line = model.predict(x_line)

    plt.figure(figsize=(8, 5))
    plt.scatter(df[args.x_col], df[args.y_col], alpha=0.8, label="Observed")
    plt.plot(x_line[args.x_col], y_line, color="red", linewidth=2, label="Regression line")
    plt.title(f"{args.y_col} vs {args.x_col}")
    plt.xlabel(args.x_col)
    plt.ylabel(args.y_col)
    plt.legend()
    plt.tight_layout()
    plt.savefig(OUTPUT_PNG, dpi=150, bbox_inches="tight")
    plt.close()
    print(f"\nSaved plot: {OUTPUT_PNG}")

    y_pred = model.predict(X)
    r2 = r2_score(y, y_pred)
    rmse = np.sqrt(mean_squared_error(y, y_pred))
    mae = mean_absolute_error(y, y_pred)

    print(f"\nR-squared: {r2:.4f}")
    print(f"RMSE:      {rmse:,.2f}")
    print(f"MAE:       {mae:,.2f}")

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
