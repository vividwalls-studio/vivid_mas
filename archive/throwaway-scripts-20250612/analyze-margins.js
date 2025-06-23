#!/usr/bin/env node

import { readFileSync } from 'fs';
import { parse } from 'csv-parse/sync';

console.log('🔍 PROFIT MARGIN ANALYSIS');
console.log('=' * 50);

// Read the pricing data
const pricingFile = '/Users/kinglerbercy/Projects/vivid_mas/services/n8n/data/shared/vividwalls-products-updated-pricing.csv';
const pricingData = readFileSync(pricingFile, 'utf-8');
const records = parse(pricingData, { 
  columns: true, 
  skip_empty_lines: true 
});

// Filter records with pricing data
const pricedRecords = records.filter(record => 
  record['Variant Price'] && 
  record['Total_Cost'] && 
  !isNaN(parseFloat(record['Variant Price'])) && 
  !isNaN(parseFloat(record['Total_Cost']))
);

console.log(`📊 Analyzing ${pricedRecords.length} priced variants\n`);

// Calculate profit margins
const marginAnalysis = pricedRecords.map(record => {
  const price = parseFloat(record['Variant Price']);
  const cost = parseFloat(record['Total_Cost']);
  const profit = price - cost;
  const marginPercent = (profit / price) * 100;
  
  return {
    handle: record.Handle,
    canvasType: record.Canvas_Type,
    size: record.Pictorem_Size_Match,
    price: price,
    cost: cost,
    profit: profit,
    marginPercent: marginPercent
  };
});

// Overall statistics
const totalPrice = marginAnalysis.reduce((sum, item) => sum + item.price, 0);
const totalCost = marginAnalysis.reduce((sum, item) => sum + item.cost, 0);
const totalProfit = marginAnalysis.reduce((sum, item) => sum + item.profit, 0);
const avgPrice = totalPrice / marginAnalysis.length;
const avgCost = totalCost / marginAnalysis.length;
const avgProfit = totalProfit / marginAnalysis.length;
const avgMargin = (avgProfit / avgPrice) * 100;

console.log('📈 OVERALL STATISTICS:');
console.log(`Average Selling Price: $${avgPrice.toFixed(2)}`);
console.log(`Average Cost (Pictorem): $${avgCost.toFixed(2)}`);
console.log(`Average Profit: $${avgProfit.toFixed(2)}`);
console.log(`Average Profit Margin: ${avgMargin.toFixed(1)}%\n`);

// By canvas type
console.log('🎨 BY CANVAS TYPE:');
const canvasTypes = ['Stretched', 'Roll'];

canvasTypes.forEach(type => {
  const typeData = marginAnalysis.filter(item => item.canvasType === type);
  if (typeData.length > 0) {
    const typeAvgPrice = typeData.reduce((sum, item) => sum + item.price, 0) / typeData.length;
    const typeAvgCost = typeData.reduce((sum, item) => sum + item.cost, 0) / typeData.length;
    const typeAvgProfit = typeData.reduce((sum, item) => sum + item.profit, 0) / typeData.length;
    const typeAvgMargin = (typeAvgProfit / typeAvgPrice) * 100;
    
    console.log(`${type} Canvas:`);
    console.log(`  - Avg Price: $${typeAvgPrice.toFixed(2)}`);
    console.log(`  - Avg Cost: $${typeAvgCost.toFixed(2)}`);
    console.log(`  - Avg Profit: $${typeAvgProfit.toFixed(2)}`);
    console.log(`  - Avg Margin: ${typeAvgMargin.toFixed(1)}%`);
    console.log(`  - Count: ${typeData.length} variants\n`);
  }
});

// By size
console.log('📏 BY SIZE:');
const uniqueSizes = [...new Set(marginAnalysis.map(item => item.size))];

uniqueSizes.forEach(size => {
  const sizeData = marginAnalysis.filter(item => item.size === size);
  if (sizeData.length > 0) {
    const sizeAvgPrice = sizeData.reduce((sum, item) => sum + item.price, 0) / sizeData.length;
    const sizeAvgCost = sizeData.reduce((sum, item) => sum + item.cost, 0) / sizeData.length;
    const sizeAvgProfit = sizeData.reduce((sum, item) => sum + item.profit, 0) / sizeData.length;
    const sizeAvgMargin = (sizeAvgProfit / sizeAvgPrice) * 100;
    
    console.log(`${size}:`);
    console.log(`  - Avg Price: $${sizeAvgPrice.toFixed(2)}`);
    console.log(`  - Avg Cost: $${sizeAvgCost.toFixed(2)}`);
    console.log(`  - Avg Profit: $${sizeAvgProfit.toFixed(2)}`);
    console.log(`  - Avg Margin: ${sizeAvgMargin.toFixed(1)}%`);
    console.log(`  - Count: ${sizeData.length} variants\n`);
  }
});

// Current vs Recommended pricing structure
console.log('💰 CURRENT PRICING STRUCTURE:');
console.log('Gallery Wrapped Canvas:');
console.log('  - 24x36: $204.00 (Cost: $85.00) → Margin: 58.3%');
console.log('  - 36x48: $315.94 (Cost: $150.45) → Margin: 52.4%');
console.log('  - 53x72: $550.92 (Cost: $289.96) → Margin: 47.4%');
console.log();
console.log('Canvas Roll:');
console.log('  - 24x36: $153.00 (Cost: $63.75) → Margin: 58.3%');
console.log('  - 36x48: $237.18 (Cost: $112.84) → Margin: 52.4%');
console.log('  - 53x72: $413.39 (Cost: $217.47) → Margin: 47.4%');
console.log();

console.log('💡 KEY INSIGHTS:');
console.log('✅ Healthy profit margins (47-58%)');
console.log('✅ Consistent margin structure across sizes');
console.log('⚠️  Margins decrease as size increases');
console.log('⚠️  Need to update CSV to use Pictorem costs in "Cost per item" column');
console.log();

console.log('🔧 NEXT STEP:');
console.log('Update the final CSV to move Pictorem costs to "Cost per item" column');