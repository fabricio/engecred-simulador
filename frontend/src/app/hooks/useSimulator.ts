'use client';

import { useState, useEffect, useCallback } from 'react';

type SegmentKey = 'PF1' | 'PF2' | 'PF3' | 'PF4' | 'PJ1' | 'PJ2' | 'PJ3' | 'PJ4';

type ProductRates = {
  [key: string]: number | null;
};

type ProductsDataType = {
  [personType: string]: {
    [modality: string]: {
      [product: string]: ProductRates;
    };
  };
};

type ResultType = {
  segment: string;
  segmentCode: SegmentKey;
  rate: number | null;
  error: string | null;
} | null;

const SEGMENTS_DATA = [
  { segment: 'PF1', minIncome: 0 },
  { segment: 'PF2', minIncome: 2000 },
  { segment: 'PF3', minIncome: 20000 },
  { segment: 'PF4', minIncome: 200000 },
  { segment: 'PJ1', minIncome: 0 },
  { segment: 'PJ2', minIncome: 4000 },
  { segment: 'PJ3', minIncome: 400000 },
  { segment: 'PJ4', minIncome: 40000000 },
];

const PRODUCTS_DATA: ProductsDataType = {
  PF: {
    'Pre-fixado': {
      Financiamento: { PF1: 0.1, PF2: 0.09, PF3: 0.08, PF4: 0.07 },
      'Sicoob engecred consignado': { PF1: null, PF2: null, PF3: null, PF4: null },
      'Emprestimo pessoal': { PF1: 0.09, PF2: 0.08, PF3: 0.07, PF4: 0.06 },
      Imoveis: { PF1: 0.2, PF2: 0.25, PF3: 0.3, PF4: 0.35 },
    },
    'Pos-fixado': {
      Financiamento: { PF1: 0.06, PF2: 0.05, PF3: 0.04, PF4: 0.03 },
      'Sicoob engecred consignado': { PF1: 0.05, PF2: 0.04, PF3: 0.03, PF4: 0.02 },
      'Emprestimo pessoal': { PF1: 0.05, PF2: 0.04, PF3: 0.03, PF4: 0.02 },
      Imoveis: { PF1: 0.4, PF2: 0.45, PF3: 0.5, PF4: 0.55 },
    },
  },
  PJ: {
    'Pre-fixado': {
      Financiamento: { PJ1: 0.1, PJ2: 0.09, PJ3: 0.08, PJ4: 0.07 },
      'Credito rural': { PJ1: 0.05, PJ2: 0.04, PJ3: 0.03, PJ4: 0.02 },
      'Emprestimo pessoal': { PJ1: 0.09, PJ2: 0.08, PJ3: 0.07, PJ4: 0.06 },
      Imóveis: { PJ1: 0.2, PJ2: 0.25, PJ3: 0.3, PJ4: 0.35 },
    },
    'Pos-fixado': {
      Financiamento: { PJ1: 0.06, PJ2: 0.05, PJ3: 0.04, PJ4: 0.03 },
      'Credito rural': { PJ1: 0.01, PJ2: 0.005, PJ3: 0.005, PJ4: 0.003 },
      'Emprestimo pessoal': { PJ1: 0.05, PJ2: 0.04, PJ3: 0.03, PJ4: 0.02 },
      Imóveis: { PJ1: 0.4, PJ2: 0.45, PJ3: 0.5, PJ4: 0.55 },
    },
  },
};

export function useSimulator() {
  const [personType, setPersonType] = useState<string>('');
  const [modality, setModality] = useState<string>('');
  const [product, setProduct] = useState<string>('');
  const [income, setIncome] = useState<string>('');
  const [result, setResult] = useState<ResultType>(null);

  const formatCurrency = (value: string) => {
    const numValue = value.replace(/\D/g, '');
    const formatted = new Intl.NumberFormat('pt-BR', {
      style: 'currency',
      currency: 'BRL',
    }).format(Number(numValue) / 100);
    return formatted;
  };

  const parseCurrency = useCallback((value: string) => {
    return parseFloat(value.replace(/[^\d,]/g, '').replace(',', '.')) || 0;
  }, []);

const getSegment = useCallback((type: string, annualIncome: number): SegmentKey => {
  const segments: SegmentKey[] = type === 'PF'
    ? ['PF1', 'PF2', 'PF3', 'PF4']
    : ['PJ1', 'PJ2', 'PJ3', 'PJ4'];

  let segment: SegmentKey = segments[0];

  for (let i = segments.length - 1; i >= 0; i--) {
    const segmentData = SEGMENTS_DATA.find(s => s.segment === segments[i]);
    if (segmentData && annualIncome >= segmentData.minIncome) {
      segment = segments[i];
      break;
    }
  }

  return segment;
}, []);

const getSegmentName = useCallback((segment: SegmentKey) => {
    const names: { [key in SegmentKey]: string } = {
      PF1: 'Basico',
      PF2: 'Intermediario',
      PF3: 'Premium',
      PF4: 'Black',
      PJ1: 'MEI',
      PJ2: 'Empresarial',
      PJ3: 'Corporativo',
      PJ4: 'Enterprise',
    };
    return names[segment] || segment;
  }, []);

  const getAvailableProducts = () => {
    if (!personType || !modality) return [];
    const products = PRODUCTS_DATA[personType]?.[modality] || {};
    return Object.keys(products).filter(productName => {
      const productRates = products[productName] as ProductRates;
      return Object.values(productRates).some(rate => rate !== null);
    });
  };

  const calculateRate = useCallback(() => {
    if (!personType || !modality || !product || !income) {
        setResult(null);
        return;
      }

      const monthlyIncome = parseCurrency(income);
      const annualIncome = monthlyIncome * 12;
      const segment = getSegment(personType, annualIncome);
      const segmentName = getSegmentName(segment);

      const rate = PRODUCTS_DATA[personType]?.[modality]?.[product]?.[segment] ?? null;

      if (rate === null || rate === undefined) {
        setResult({
          segment: segmentName,
          segmentCode: segment,
          rate: null,
          error: 'Produto nao disponivel para este segmento',
        });
      } else {
        setResult({
          segment: segmentName,
          segmentCode: segment,
          rate: rate,
          error: null,
        });
      }  }, [personType, modality, product, income, parseCurrency, getSegment, getSegmentName]);



  useEffect(() => {
    if (personType) {
      setModality('');
      setProduct('');
      setResult(null);
    }
  }, [personType]);

  useEffect(() => {
    if (modality) {
      setProduct('');
      setResult(null);
    }
  }, [modality]);

  useEffect(() => {
    calculateRate();
  }, [personType, modality, product, income, calculateRate]);

  const handleIncomeChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const formatted = formatCurrency(e.target.value);
    setIncome(formatted);
  };

  return {
    personType,
    setPersonType,
    modality,
    setModality,
    product,
    setProduct,
    income,
    handleIncomeChange,
    result,
    getAvailableProducts,
  };
}
