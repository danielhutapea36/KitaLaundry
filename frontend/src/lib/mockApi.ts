import { MOCK_ORDERS, MOCK_ADDRESSES } from '@/data/dummyData'

let lastCreatedOrder: any = null;

export const mockCustomerAPI = {
  getOrders: () => Promise.resolve({ data: { success: true, data: { orders: lastCreatedOrder ? [lastCreatedOrder, ...MOCK_ORDERS] : MOCK_ORDERS } } }),
  createOrder: (orderData: any) => {
    let subtotal = 0;
    orderData.items.forEach((item: any) => {
      let price = 7000;
      if (item.itemType && item.itemType.endsWith('_bed')) {
        price = 14000;
      }
      subtotal += price * (item.quantity || 1);
    });
    if (orderData.isExpress) subtotal *= 1.5;
    const tax = subtotal * 0.1;
    const total = subtotal + tax;

    lastCreatedOrder = {
      _id: `new_${Date.now()}`,
      orderNumber: `ORD-${Math.floor(1000 + Math.random() * 9000)}`,
      status: 'placed',
      items: orderData.items,
      totalAmount: total,
      isExpress: orderData.isExpress,
      createdAt: new Date().toISOString(),
      statusHistory: [{ status: 'placed', date: new Date().toISOString(), updatedAt: new Date().toISOString() }],
      pricing: { subtotal, tax, deliveryCharge: 0, expressCharge: 0, discount: 0, total },
      paymentMethod: orderData.paymentMethod || 'cod',
      paymentStatus: orderData.paymentMethod === 'online' ? 'paid' : 'pending',
      pickupDate: orderData.pickupDate || new Date().toISOString(),
      pickupTimeSlot: orderData.pickupTimeSlot || '09:00-11:00',
      deliveryAddress: MOCK_ADDRESSES.find((a: any) => a._id === orderData.deliveryAddress) || MOCK_ADDRESSES[0],
      pickupAddress: MOCK_ADDRESSES.find((a: any) => a._id === orderData.pickupAddress) || MOCK_ADDRESSES[0],
      specialInstructions: orderData.specialInstructions
    };
    return Promise.resolve({ data: { success: true, data: { order: { _id: lastCreatedOrder._id } } } });
  },
  getOrder: (id: string) => {
    if (lastCreatedOrder && lastCreatedOrder._id === id) {
      return Promise.resolve({ data: { success: true, data: { order: lastCreatedOrder } } });
    }
    return Promise.resolve({ data: { success: true, data: { order: { ...MOCK_ORDERS[0], _id: id } } } });
  },
  getOrderTracking: () => Promise.resolve({ data: { success: true, data: { tracking: [{ status: 'placed', date: new Date().toISOString() }, { status: 'in_process', date: new Date().toISOString() }] } } }),
  cancelOrder: () => Promise.resolve({ data: { success: true } }),
  rateOrder: () => Promise.resolve({ data: { success: true } }),
  reorder: () => Promise.resolve({ data: { success: true } }),

  getAddresses: () => Promise.resolve({ data: { success: true, data: { addresses: MOCK_ADDRESSES } } }),
  addAddress: (address: any) => Promise.resolve({ data: { success: true, data: { address: { ...address, _id: Date.now().toString() } } } }),
  updateAddress: (id: string, address: any) => Promise.resolve({ data: { success: true, data: { address: { ...address, _id: id } } } }),
  deleteAddress: () => Promise.resolve({ data: { success: true } }),
  setDefaultAddress: (id: string) => Promise.resolve({ data: { success: true, data: { address: { _id: id, isDefault: true } } } }),

  getNotifications: () => Promise.resolve({ data: { success: true, data: { notifications: [] } } }),
  markNotificationRead: () => Promise.resolve({ data: { success: true } })
};

export const mockServicesAPI = {
  calculatePricing: (items: any[], isExpress: boolean) => {
    let subtotal = 0;
    items.forEach(item => {
      let price = 7000;
      if (item.itemType && item.itemType.endsWith('_bed')) {
        price = 14000;
      }
      subtotal += price * (item.quantity || 1);
    });
    if (isExpress) subtotal *= 1.5;
    const tax = subtotal * 0.1;
    const total = subtotal + tax;
    return Promise.resolve({ data: { success: true, data: { subtotal, tax, orderTotal: { total } } } });
  },
  getTimeSlots: () => Promise.resolve({ data: { success: true, data: { timeSlots: ['09:00-11:00', '11:00-13:00', '13:00-15:00', '15:00-17:00'] } } }),
  checkServiceAvailability: () => Promise.resolve({ data: { success: true, data: { available: true } } })
};

export const mockAdminAPI = {
  getOrders: () => Promise.resolve({ data: { success: true, data: { orders: [] } } }),
  assignOrderToBranch: () => Promise.resolve({ data: { success: true } }),
  assignOrderToLogistics: () => Promise.resolve({ data: { success: true } }),
  processRefund: () => Promise.resolve({ data: { success: true } }),
  getCustomers: () => Promise.resolve({ data: { success: true, data: { customers: [] } } }),
  updateCustomerStatus: () => Promise.resolve({ data: { success: true } }),
  toggleVIPStatus: () => Promise.resolve({ data: { success: true } }),
};

export const mockAuthAPI = {
  login: (credentials: { email: string; password: string }) =>
    Promise.resolve({
      data: {
        success: true,
        data: {
          token: 'demo-token',
          user: {
            _id: 'demo-user-001',
            name: 'Demo Customer',
            email: credentials.email,
            phone: '08123456789',
            role: 'customer' as const,
            isActive: true,
          },
        },
      },
    }),
  register: () => Promise.resolve({ data: { success: true } }),
  verifyEmail: () => Promise.resolve({ data: { success: true } }),
  resendVerification: () => Promise.resolve({ data: { success: true } }),
  getProfile: () => Promise.resolve({ data: { success: true, data: { user: { name: 'Demo Customer', email: 'customer@demo.com', phone: '08123456789' } } } }),
};

export const mockBarcodeAPI = {
  scanBarcode: () => Promise.resolve({ data: { success: true } }),
  getOrderBarcode: () => Promise.resolve({ data: { success: true } }),
  updateStatusViaScan: () => Promise.resolve({ data: { success: true } }),
  bulkScan: () => Promise.resolve({ data: { success: true } }),
};
