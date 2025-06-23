/**
 * VividWalls Product Page JavaScript
 * Handles variant selection, thumbnail navigation, and gallery wrap pricing
 */

(function() {
  'use strict';

  // Configuration
  const config = {
    galleryWrapPrices: {}, // Will be populated dynamically from data attributes
    defaultVariantSize: '24x36',
    currency: 'USD',
    currencySymbol: '$'
  };

  // State management
  const state = {
    selectedVariant: null,
    selectedVariantId: null,
    galleryWrapChecked: false, // Start unchecked as upgrade
    quantity: 1,
    isLoading: false
  };

  // DOM Elements cache
  const elements = {};

  /**
   * Initialize DOM element references
   */
  function initializeElements() {
    elements.variantOptions = document.querySelectorAll('.vividwalls-variant-option');
    elements.galleryWrapCheckbox = document.querySelector('.vividwalls-gallery-wrap-checkbox input[type="checkbox"]');
    elements.checkboxVisual = document.querySelector('.vividwalls-checkbox-visual');
    elements.checkIcon = document.querySelector('.vividwalls-check-icon');
    elements.totalPriceDisplay = document.querySelector('.vividwalls-total-price');
    elements.selectedWidth = document.querySelector('.vividwalls-dimensions .vividwalls-width');
    elements.selectedHeight = document.querySelector('.vividwalls-dimensions .vividwalls-height');
    elements.quantityInput = document.querySelector('.vividwalls-quantity-input');
    elements.quantityMinus = document.querySelector('.vividwalls-quantity-minus');
    elements.quantityPlus = document.querySelector('.vividwalls-quantity-plus');
    elements.skuDisplay = document.querySelector('.vividwalls-sku');
    elements.variantIdInput = document.querySelector('input[name="id"]');
    elements.galleryWrapPriceInput = document.querySelector('input[name="properties[_gallery_wrap_price]"]');
    elements.productForm = document.querySelector('#vividwalls-product-form');
    elements.thumbnails = document.querySelectorAll('.vividwalls-thumbnail-wrapper');
    elements.mainImage = document.querySelector('.vividwalls-main-img');
    elements.readMoreBtn = document.querySelector('.vividwalls-read-more');
    elements.productDescription = document.querySelector('.vividwalls-description-text');
    elements.installmentPrice = document.querySelector('.vividwalls-installment-price');
  }

  /**
   * Format price with currency
   */
  function formatPrice(cents) {
    const price = (cents / 100).toFixed(2);
    return `${config.currencySymbol}${price} ${config.currency}`;
  }

  /**
   * Update total price based on selections
   */
  function updateTotalPrice() {
    if (!state.selectedVariant || !elements.totalPriceDisplay) return;

    const basePrice = parseFloat(state.selectedVariant.dataset.variantPrice);
    const variantSize = state.selectedVariant.dataset.variantSize;
    let additionalPrice = 0;

    if (state.galleryWrapChecked && variantSize) {
      // Get gallery wrap price from data attribute
      const galleryWrapPrice = parseFloat(state.selectedVariant.dataset.galleryWrapPrice) || 0;
      if (galleryWrapPrice > 0) {
        additionalPrice = galleryWrapPrice * 100; // Convert to cents
        if (elements.galleryWrapPriceInput) {
          elements.galleryWrapPriceInput.value = galleryWrapPrice;
        }
      }
    } else if (elements.galleryWrapPriceInput) {
      elements.galleryWrapPriceInput.value = 0;
    }

    // Calculate price per item
    const pricePerItem = basePrice + additionalPrice;
    
    // Get current quantity
    const quantity = parseInt(elements.quantityInput?.value) || state.quantity || 1;
    
    // Calculate total price
    const totalPrice = pricePerItem * quantity;
    
    elements.totalPriceDisplay.textContent = formatPrice(totalPrice);

    // Update installment price
    updateInstallmentPrice(totalPrice);
  }

  /**
   * Update installment price display
   */
  function updateInstallmentPrice(totalPrice) {
    const installmentPrice = totalPrice / 4;
    if (elements.installmentPrice) {
      elements.installmentPrice.textContent = formatPrice(installmentPrice).replace(' USD', '');
    }
  }

  /**
   * Update gallery wrap checkbox visual state
   */
  function updateGalleryWrapVisual(checked) {
    if (!elements.checkboxVisual || !elements.checkIcon) return;

    if (checked) {
      elements.checkboxVisual.classList.add('checked');
      elements.checkIcon.classList.add('visible');
    } else {
      elements.checkboxVisual.classList.remove('checked');
      elements.checkIcon.classList.remove('visible');
    }
  }

  /**
   * Select variant by size
   */
  function selectVariantBySize(size) {
    const variant = Array.from(elements.variantOptions).find(
      opt => opt.dataset.variantSize === size
    );
    
    if (variant) {
      selectVariant(variant);
    }
  }

  /**
   * Select a variant
   */
  function selectVariant(variantElement) {
    if (!variantElement) return;

    // Update state
    state.selectedVariant = variantElement;
    state.selectedVariantId = variantElement.dataset.variantId;

    // Update variant ID input
    if (elements.variantIdInput) {
      elements.variantIdInput.value = state.selectedVariantId;
    }

    // Update visual state for all variants
    elements.variantOptions.forEach(opt => {
      if (opt === variantElement) {
        opt.classList.add('selected');
      } else {
        opt.classList.remove('selected');
      }
    });

    // Update main display dimensions
    const size = variantElement.dataset.variantSize;
    if (size) {
      const [width, height] = size.split('x');
      if (elements.selectedWidth) elements.selectedWidth.textContent = width;
      if (elements.selectedHeight) elements.selectedHeight.textContent = height;
    }

    // Update SKU
    if (elements.skuDisplay) {
      const productHandle = window.vividwallsProductHandle || 'PRODUCT';
      const size = variantElement.dataset.variantSize || '24x36';
      // Format SKU as PRODUCT-NAME-SIZE (e.g., OLIVE-WEAVE-24X36)
      const formattedHandle = productHandle.toUpperCase().replace(/-/g, '-');
      elements.skuDisplay.textContent = `SKU: ${formattedHandle}-${size.toUpperCase()}`;
    }

    // Update main image if variant has image
    const variantImage = variantElement.dataset.variantImage;
    if (variantImage && elements.mainImage) {
      elements.mainImage.src = variantImage;
      elements.mainImage.srcset = '';
    }

    // Update total price
    updateTotalPrice();
    
    // Update thumbnail selection
    updateThumbnailSelection(state.selectedVariantId);
  }

  /**
   * Handle variant selection
   */
  function handleVariantClick(event) {
    const variant = event.currentTarget;
    
    // Check if variant is available
    if (variant.dataset.variantAvailable === 'false') {
      return;
    }

    selectVariant(variant);
  }

  /**
   * Handle gallery wrap checkbox change
   */
  function handleGalleryWrapChange() {
    state.galleryWrapChecked = elements.galleryWrapCheckbox.checked;
    updateGalleryWrapVisual(state.galleryWrapChecked);
    updateTotalPrice();
  }

  /**
   * Handle quantity changes
   */
  function handleQuantityChange(delta) {
    const currentValue = parseInt(elements.quantityInput.value) || 1;
    const newValue = Math.max(1, currentValue + delta);
    
    elements.quantityInput.value = newValue;
    state.quantity = newValue;
    
    // Update total price when quantity changes
    updateTotalPrice();
  }

  /**
   * Update thumbnail selection to match variant
   */
  function updateThumbnailSelection(variantId) {
    const thumbnailItems = document.querySelectorAll('.vividwalls-thumbnail-item');
    
    thumbnailItems.forEach(item => {
      const wrapper = item.querySelector('.vividwalls-thumbnail-wrapper');
      const existingIndicator = wrapper.querySelector('.vividwalls-selected-indicator');
      
      if (existingIndicator) {
        existingIndicator.remove();
      }
      
      if (item.dataset.variantId === variantId) {
        const indicator = document.createElement('div');
        indicator.className = 'vividwalls-selected-indicator';
        wrapper.insertBefore(indicator, wrapper.firstChild);
      }
    });
  }

  /**
   * Handle thumbnail clicks
   */
  function handleThumbnailClick(event) {
    const thumbnailItem = event.currentTarget.closest('.vividwalls-thumbnail-item');
    const variantId = thumbnailItem?.dataset.variantId;
    
    if (!variantId) return;
    
    // Find and select the corresponding variant
    const variantOption = document.querySelector(`.vividwalls-variant-option[data-variant-id="${variantId}"]`);
    if (variantOption) {
      selectVariant(variantOption);
    }
  }

  /**
   * Handle read more functionality
   */
  function handleReadMore() {
    if (!elements.productDescription || !elements.readMoreBtn) return;

    const isExpanded = elements.productDescription.classList.contains('expanded');
    
    if (isExpanded) {
      elements.productDescription.classList.remove('expanded');
      elements.readMoreBtn.textContent = 'read more';
    } else {
      elements.productDescription.classList.add('expanded');
      elements.readMoreBtn.textContent = 'read less';
    }
  }

  /**
   * Handle form submission
   */
  function handleFormSubmit(event) {
    // Let Shopify handle the form submission
    // This is just for any pre-submission validation if needed
    
    if (!state.selectedVariantId) {
      event.preventDefault();
      alert('Please select a size option');
      return false;
    }
  }

  /**
   * Attach event listeners
   */
  function attachEventListeners() {
    // Variant selection
    elements.variantOptions.forEach(option => {
      option.addEventListener('click', handleVariantClick);
    });

    // Gallery wrap checkbox
    if (elements.galleryWrapCheckbox) {
      elements.galleryWrapCheckbox.addEventListener('change', handleGalleryWrapChange);
    }

    // Quantity controls
    if (elements.quantityMinus) {
      elements.quantityMinus.addEventListener('click', () => handleQuantityChange(-1));
    }
    
    if (elements.quantityPlus) {
      elements.quantityPlus.addEventListener('click', () => handleQuantityChange(1));
    }

    // Quantity input validation
    if (elements.quantityInput) {
      elements.quantityInput.addEventListener('change', () => {
        const value = parseInt(elements.quantityInput.value) || 1;
        elements.quantityInput.value = Math.max(1, value);
        state.quantity = value;
        updateTotalPrice();
      });
      
      elements.quantityInput.addEventListener('input', () => {
        const value = parseInt(elements.quantityInput.value) || 1;
        state.quantity = value;
        updateTotalPrice();
      });
    }

    // Thumbnails
    const thumbnailItems = document.querySelectorAll('.vividwalls-thumbnail-item');
    thumbnailItems.forEach(item => {
      item.addEventListener('click', handleThumbnailClick);
    });

    // Read more
    if (elements.readMoreBtn) {
      elements.readMoreBtn.addEventListener('click', handleReadMore);
    }

    // Form submission
    if (elements.productForm) {
      elements.productForm.addEventListener('submit', handleFormSubmit);
    }
  }

  /**
   * Initialize the product page
   */
  function initialize() {
    console.log('Initializing VividWalls product page...');
    
    // Initialize DOM elements
    initializeElements();
    
    // Set initial states
    if (elements.galleryWrapCheckbox) {
      // Start with gallery wrap unchecked (it's an upgrade)
      elements.galleryWrapCheckbox.checked = false;
      state.galleryWrapChecked = false;
      updateGalleryWrapVisual(false);
    }
    
    // Select default variant or first selected
    const selectedVariant = document.querySelector('.vividwalls-variant-option.selected');
    if (selectedVariant) {
      selectVariant(selectedVariant);
    } else {
      selectVariantBySize(config.defaultVariantSize);
    }
    
    // Attach event listeners
    attachEventListeners();
    
    console.log('VividWalls product page initialized successfully');
  }

  // Wait for DOM to be ready
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', initialize);
  } else {
    // DOM is already ready
    initialize();
  }

  // Expose API for debugging
  window.vividwallsDebug = {
    config,
    state,
    elements,
    updateTotalPrice,
    selectVariantBySize
  };

})();