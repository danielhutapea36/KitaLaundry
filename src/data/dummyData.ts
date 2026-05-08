import { 
  CreditCard, 
  Truck, 
  Sparkles, 
  CheckCircle,
  Shirt,
  Award,
  Shield,
  Zap,
  Star,
  Package,
  RefreshCw,
  Headphones,
  Ticket,
  HelpCircle,
  Clock
} from 'lucide-react'

export const HOW_IT_WORKS_DATA = [
  {
    id: 1,
    title: 'Order Online',
    description: 'Place your laundry request in just a few clicks.',
    image: 'https://images.unsplash.com/photo-1556742049-0cfed4f6a45d?ixlib=rb-4.0.3&auto=format&fit=crop&w=400&q=80',
    icon: CreditCard
  },
  {
    id: 2,
    title: 'Pick Up',
    description: 'We collect your clothes right from your doorstep.',
    image: 'https://images.unsplash.com/photo-1582735689369-4fe89db7114c?ixlib=rb-4.0.3&auto=format&fit=crop&w=400&q=80',
    icon: Truck
  },
  {
    id: 3,
    title: 'Cleaning',
    description: 'Expert care with advanced cleaning technology.',
    image: 'https://images.unsplash.com/photo-1545173168-9f1947eebb7f?ixlib=rb-4.0.3&auto=format&fit=crop&w=400&q=80',
    icon: Sparkles
  },
  {
    id: 4,
    title: 'Drop Off',
    description: 'Fresh, clean clothes delivered back to you on time.',
    image: '/images/del.jpg',
    icon: CheckCircle
  }
]

export const SERVICES_DATA = [
  {
    id: 1,
    title: 'Wash & Fold',
    description: 'Fresh, clean, neatly folded clothes.\nPerfect for everyday wear.',
    icon: Shirt
  },
  {
    id: 2,
    title: 'Wash & Iron',
    description: 'Clean, crisp, wrinkle-free garments.\nReady to wear daily.',
    icon: Sparkles
  },
  {
    id: 3,
    title: 'Premium Laundry',
    description: 'Gentle care for special fabrics.\nExtra attention to detail.',
    icon: Award
  },
  {
    id: 4,
    title: 'Dry Clean',
    description: 'Delicate care for formal wear.\nSuits, blazers & more.',
    icon: Shield
  },
  {
    id: 5,
    title: 'Steam Press',
    description: 'Smooth, polished finish with steam.\nProfessional ironing service.',
    icon: Zap
  },
  {
    id: 6,
    title: 'Starching',
    description: 'Perfect, lasting stiffness for clothes.\nIdeal for cottons & sarees.',
    icon: Star
  },
  {
    id: 7,
    title: 'Premium Steam Press',
    description: 'Extra-fine, careful press service.\nFor premium outfits only.',
    icon: CheckCircle
  },
  {
    id: 8,
    title: 'Premium Dry Clean',
    description: 'Luxury care for branded items.\nDesigner clothing experts.',
    icon: Truck
  }
]

export const TESTIMONIALS_DATA = [
  {
    id: 1,
    name: 'Divya K.',
    review: 'I gave them my silk saree and was honestly worried. But they handled it with such care. Impressive service and safe for delicate fabrics!',
    rating: 5
  },
  {
    id: 2,
    name: 'Rajat T.',
    review: 'Very smooth process — booked on the app, got a confirmation instantly, and pickup arrived right on time. Great for busy people like me.',
    rating: 5
  },
  {
    id: 3,
    name: 'Tanvi M.',
    review: 'Affordable prices and great quality. Clothes were perfectly ironed and smelled so fresh. 10/10 for service!',
    rating: 5
  },
  {
    id: 4,
    name: 'Karan V.',
    review: "This is my third time using KitaLaundry and I'm never going back to hand washing or dry cleaning shops. So easy and dependable!",
    rating: 5
  },
  {
    id: 5,
    name: 'Sneha R.',
    review: 'Love their attention to detail. Even stubborn stains were removed completely without damaging the fabric. Highly recommend!',
    rating: 5
  },
  {
    id: 6,
    name: 'Rahul P.',
    review: 'The express service is a lifesaver. Needed my suit dry cleaned for a last-minute meeting, and they delivered it perfectly the same day.',
    rating: 5
  }
]

export const FAQ_CATEGORIES_DATA = {
  general: [
    {
      question: "How does KitaLaundry work?",
      answer: "KitaLaundry makes laundry simple! Just place an order online, schedule a pickup time, and our team will collect your clothes from your doorstep. We clean them professionally and deliver them back fresh and folded within 24-48 hours."
    },
    {
      question: "What areas do you serve?",
      answer: "We currently serve 5+ major cities across Medan including Delhi NCR, Mumbai, Bangalore, Hyderabad, and Chennai. We're constantly expanding to new areas. Check our service availability by entering your pincode on the homepage."
    },
    {
      question: "What are your operating hours?",
      answer: "Our pickup and delivery services operate from 8 AM to 9 PM, 7 days a week. Customer support is available 24/7 via phone, email, and WhatsApp."
    },
    {
      question: "How do I track my order?",
      answer: "Once your order is placed, you'll receive SMS and email updates at every stage. You can also track your order in real-time through your customer dashboard or by calling our support team."
    }
  ],
  orders: [
    {
      question: "How do I place an order?",
      answer: "You can place an order through our website or mobile app. Simply select your service type, add items, choose pickup/delivery times, and confirm. It takes less than 2 minutes!"
    },
    {
      question: "Can I modify or cancel my order?",
      answer: "Yes! You can modify or cancel your order up to 2 hours before the scheduled pickup time. Go to 'My Orders' in your dashboard and select the order you want to change."
    },
    {
      question: "What is the minimum order value?",
      answer: "There's no minimum order value! You can place orders for even a single item. However, orders above Rp200 qualify for free pickup and delivery."
    },
    {
      question: "Do you offer same-day service?",
      answer: "Yes! Our Express Service provides same-day pickup and delivery for urgent needs. An additional express charge of Rp50 applies. Orders must be placed before 2 PM for same-day delivery."
    }
  ],
  payment: [
    {
      question: "What payment methods do you accept?",
      answer: "We accept Cash on Delivery (COD), UPI payments, credit/debit cards (Visa, Mastercard, RuPay), and digital wallets like Paytm, PhonePe, and Google Pay."
    },
    {
      question: "Is online payment secure?",
      answer: "Absolutely! We use industry-standard SSL encryption and partner with trusted payment gateways like Razorpay to ensure your payment information is always secure."
    },
    {
      question: "Do you offer any discounts?",
      answer: "Yes! We offer bulk order discounts: 5% off on orders above Rp500, 10% off above Rp1000, and 15% off above Rp2000. Discounts are applied automatically at checkout."
    },
    {
      question: "Can I get a refund?",
      answer: "If you're not satisfied with our service, we'll redo your order for free. If you're still not happy, we provide a full refund within 7 business days. Contact our support team to initiate a refund."
    }
  ],
  services: [
    {
      question: "What services do you offer?",
      answer: "We offer Wash & Fold, Dry Cleaning, Ironing, Steam Press, Starching, and Premium services for delicate fabrics. Each service is handled by trained professionals using quality products."
    },
    {
      question: "How do you handle delicate fabrics?",
      answer: "Our dry cleaning service specializes in delicate fabrics like silk, wool, cashmere, and designer garments. We use eco-friendly solvents and have trained professionals who understand fabric care requirements."
    },
    {
      question: "Do you provide stain removal?",
      answer: "Yes! Stain removal is included in our dry cleaning service. For tough stains, our experts use specialized treatments. Please inform us about any specific stains when placing your order."
    },
    {
      question: "What if my clothes get damaged?",
      answer: "While rare, if any item gets damaged during our process, we provide full compensation based on the item's declared value. We also have comprehensive insurance coverage for all orders."
    }
  ]
}

export const QUICK_HELP_CARDS_DATA = [
  {
    icon: Package,
    title: "Track Order",
    description: "Check real-time status of your laundry",
    link: "/customer/orders",
    color: "bg-blue-500"
  },
  {
    icon: Ticket,
    title: "Raise Ticket",
    description: "Report an issue or get help",
    link: "/customer/support/new",
    color: "bg-purple-500"
  },
  {
    icon: RefreshCw,
    title: "Request Refund",
    description: "Initiate refund for any order",
    link: "/customer/support/new?category=payment",
    color: "bg-orange-500"
  },
  {
    icon: Headphones,
    title: "Live Support",
    description: "Chat with our support team",
    link: "/customer/support",
    color: "bg-teal-500"
  }
]

export const CATEGORY_TABS_DATA = [
  { id: 'general', label: 'General', icon: HelpCircle },
  { id: 'orders', label: 'Orders', icon: Package },
  { id: 'payment', label: 'Payment', icon: CreditCard },
  { id: 'services', label: 'Services', icon: Sparkles }
]

export const SERVICES_PAGE_DATA = [
  { id: 'wash-fold', name: 'Wash & Fold', icon: Shirt, description: 'Regular washing and folding service for everyday clothes', price: 'Starting Rp25/item', features: ['Same day pickup', 'Eco-friendly detergents', 'Neatly folded'] },
  { id: 'dry-cleaning', name: 'Dry Cleaning', icon: Sparkles, description: 'Professional dry cleaning for delicate and formal wear', price: 'Starting Rp60/item', features: ['Expert care', 'Stain removal', 'Premium finish'] },
  { id: 'laundry', name: 'Laundry Service', icon: Package, description: 'Complete laundry service with wash, dry and iron', price: 'Starting Rp30/item', features: ['Full service', 'Quick turnaround', 'Quality assured'] },
  { id: 'shoe-cleaning', name: 'Shoe Cleaning', icon: Award, description: 'Professional shoe care and cleaning services', price: 'Starting Rp80/pair', features: ['Deep cleaning', 'Polish & shine', 'Odor removal'] },
  { id: 'express', name: 'Express Service', icon: Clock, description: 'Same-day delivery for urgent laundry needs', price: 'Starting Rp45/item', features: ['4-6 hour delivery', 'Priority handling', 'Premium care'] }
]

export const HOW_WE_WORK_STEPS = [
  { id: 1, title: 'Schedule Pickup', subtitle: 'Book in seconds', description: 'Use our app or website to schedule a pickup at your convenient time.', features: ['Easy online booking', 'Flexible time slots', 'Instant confirmation', 'Real-time tracking', 'One-click reschedule'], image: 'https://images.unsplash.com/photo-1512941937669-90a1b58e7e9c?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80' },
  { id: 2, title: 'We Collect', subtitle: 'Doorstep pickup', description: 'Our trained delivery partner arrives at your doorstep to collect your laundry.', features: ['Free doorstep pickup', 'Verified professionals', 'Careful handling', 'Itemized receipt', 'Special care notes'], image: 'https://images.unsplash.com/photo-1580674285054-bed31e145f59?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80' },
  { id: 3, title: 'Expert Cleaning', subtitle: 'Premium care', description: 'Your clothes are cleaned with premium eco-friendly detergents by trained experts.', features: ['Eco-friendly detergents', 'Advanced machines', 'Stain treatment', 'Quality inspection', 'Delicate fabric care'], image: 'https://images.unsplash.com/photo-1517677208171-0bc6725a3e60?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80' },
  { id: 4, title: 'Delivery', subtitle: 'Fresh & folded', description: 'Your fresh, clean clothes are delivered back to your doorstep right on time.', features: ['On-time delivery', 'Neatly packed', 'Quality check', 'Contactless option', '100% satisfaction'], image: '/images/del.jpg' }
]

export const SERVICES_FAQ_DATA = [
  { question: "What types of clothes do you clean?", answer: "We clean all types of garments including everyday wear, formal clothes, delicates, woolens, silks, sarees, suits, curtains, bed sheets, and more." },
  { question: "How do you handle delicate fabrics?", answer: "Delicate fabrics like silk, wool, and cashmere receive special attention with gentle, fabric-specific detergents and appropriate cleaning methods." },
  { question: "What is the difference between Wash & Fold and Dry Cleaning?", answer: "Wash & Fold is regular water-based washing for everyday clothes. Dry Cleaning uses special solvents for delicate fabrics and formal wear." },
  { question: "Can you remove tough stains?", answer: "Yes! Our expert technicians specialize in stain removal including oil, ink, wine, coffee, and food stains." },
  { question: "How long does the service take?", answer: "Standard service takes 24-48 hours. Express service is available for same-day or next-day delivery." },
  { question: "Do you provide packaging for delivered clothes?", answer: "Yes, all cleaned garments are carefully packed. Formal wear is delivered on hangers with protective covers." }
]

export const PRICING_FAQ_DATA = [
  {
    question: "Do you charge for pickup and delivery?",
    answer: "No, pickup and delivery are completely free for all orders above Rp200. For orders below Rp200, a nominal charge of Rp30 applies."
  },
  {
    question: "What payment methods do you accept?",
    answer: "We accept Cash on Delivery (COD), UPI payments, credit/debit cards, and digital wallets like Paytm, PhonePe, and Google Pay."
  },
  {
    question: "Is there a minimum order value?",
    answer: "No minimum order value required! Orders above Rp200 qualify for free pickup and delivery."
  },
  {
    question: "Do you offer any discounts for regular customers?",
    answer: "Yes, we have membership plans and offer bulk order discounts up to 15%."
  }
]