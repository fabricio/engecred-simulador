'use client';

import { useState, useEffect, useCallback } from 'react';
import { Segment, Product, Rate, Result } from '@/types/simulator';

export function useSimulator() {
  const [personType, setPersonType] = useState<string>('');
  const [modality, setModality] = useState<string>('');
  const [product, setProduct] = useState<string>('');
  const [income, setIncome] = useState<string>('');
  const [result, setResult] = useState<Result>(null);
  const [segments, setSegments] = useState<Segment[]>([]);
  const [products, setProducts] = useState<Product[]>([]);
  const [rates, setRates] = useState<Rate[]>([]);
  const [loading, setLoading] = useState(true);

  // Carrega os dados do banco
  useEffect(() => {
    const fetchData = async () => {
      try {
        const [segmentsRes, productsRes] = await Promise.all([
          fetch('/api/segments'),
          fetch('/api/products')
        ]);

        if (!segmentsRes.ok || !productsRes.ok) {
          throw new Error('Erro ao carregar dados');
        }

        const segmentsData = await segmentsRes.json();
        const productsData = await productsRes.json();

        setSegments(segmentsData);
        setProducts(productsData);
      } catch (error) {
        console.error('Erro ao carregar dados:', error);
      } finally {
        setLoading(false);
      }
    };

    fetchData();
  }, []);

  // Carrega as taxas quando produto ou segmento mudar
  useEffect(() => {
    const fetchRates = async () => {
      if (!personType || !modality) return;

      try {
        const response = await fetch('/api/rates');
        if (!response.ok) {
          throw new Error('Erro ao carregar taxas');
        }
        const ratesData = await response.json();
        setRates(ratesData);
      } catch (error) {
        console.error('Erro ao carregar taxas:', error);
      }
    };

    fetchRates();
  }, [personType, modality]);

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

  const getSegment = useCallback((type: string, annualIncome: number): string => {
    const filteredSegments = segments.filter(s => s.PersonType === type);
    let segment = filteredSegments[0];

    for (let i = filteredSegments.length - 1; i >= 0; i--) {
      if (annualIncome >= filteredSegments[i].MinAnnualIncome) {
        segment = filteredSegments[i];
        break;
      }
    }

    return segment.Code;
  }, [segments]);

  const getAvailableProducts = () => {
    if (!personType || !modality) return [];

    // Filtra os produtos pelo tipo de pessoa e modalidade
    const filteredProducts = products.filter(
      p => p.PersonType === personType && p.Modality === modality
    );

    // Filtra os produtos que tem pelo menos uma taxa nao nula
    const availableProducts = filteredProducts.filter(product => {
      const productRates = rates.filter(
        r => r.ProductName === product.Name && 
             r.PersonType === personType && 
             r.Modality === modality
      );
      
      // Verifica se existe pelo menos uma taxa nao nula para este produto
      return productRates.some(rate => rate.Rate !== null);
    });

    return availableProducts.map(p => p.Name);
  };

  const calculateRate = useCallback(() => {
    if (!personType || !modality || !product || !income) {
      setResult(null);
      return;
    }

    const monthlyIncome = parseCurrency(income);
    const annualIncome = monthlyIncome * 12;
    const segmentCode = getSegment(personType, annualIncome);
    const segment = segments.find(s => s.Code === segmentCode);

    if (!segment) {
      setResult(null);
      return;
    }

    const rate = rates.find(
      r => r.ProductName === product && 
           r.SegmentCode === segmentCode &&
           r.PersonType === personType &&
           r.Modality === modality
    );

    if (!rate || rate.Rate === null) {
      setResult({
        segment: segment.Name,
        segmentCode: segment.Code,
        rate: null,
        error: 'Produto nao disponivel para este segmento',
      });
    } else {
      setResult({
        segment: segment.Name,
        segmentCode: segment.Code,
        rate: rate.Rate,
        error: null,
      });
    }
  }, [personType, modality, product, income, parseCurrency, getSegment, segments, rates]);

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
    loading,
  };
}