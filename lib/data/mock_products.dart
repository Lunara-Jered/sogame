import '../models/product.dart';

const mockProducts = <Product>[
  Product(
    id: 1,
    category: ProductCategory.appliance,
    name: 'Machine à laver',
    reference: 'REF-WM-001',
    price: 170000,
    availability: ProductAvailability.inStock,
    iconKey: 'washer',
    description:
        'Lave-linge frontale silencieux, idéal pour un usage familial quotidien. Capacité 8 kg, essorage efficace et programmes multiples.',
    specifications: [
      'Capacité 8 kg',
      'Classe énergétique A++',
      'Vitesse d’essorage 1200 tr/min',
    ],
  ),
  Product(
    id: 2,
    category: ProductCategory.appliance,
    name: 'Réfrigérateur combiné',
    reference: 'REF-RF-002',
    price: 190000,
    availability: ProductAvailability.inStock,
    iconKey: 'fridge',
    description:
        'Réfrigérateur combiné avec congélateur, conservation optimale des aliments et faible consommation énergétique.',
    specifications: ['Volume net 320 L', 'No Frost', 'Classe énergétique A+'],
  ),
  Product(
    id: 3,
    category: ProductCategory.diy,
    name: 'Boîte à outils complète',
    reference: 'REF-TB-003',
    price: 25000,
    availability: ProductAvailability.inStock,
    iconKey: 'toolbox',
    description:
        'Boîte à outils professionnelle avec tous les essentiels pour les travaux du quotidien. Rangement organisé et durable.',
    specifications: [
      '48 pièces incluses',
      'Boîtier renforcé',
      'Outils acier trempé',
    ],
  ),
  Product(
    id: 4,
    category: ProductCategory.diy,
    name: 'Lot de vis et chevilles',
    reference: 'REF-SC-004',
    price: 8000,
    availability: ProductAvailability.limited,
    iconKey: 'screw',
    description:
        'Assortiment complet de vis et chevilles pour fixations murales et assemblage. Qualité professionnelle.',
    specifications: [
      '250 pièces assorties',
      'Acier zingué',
      'Boîte de rangement incluse',
    ],
  ),
];
