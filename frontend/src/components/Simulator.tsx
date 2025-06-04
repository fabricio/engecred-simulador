'use client';

import React from 'react';
import { Calculator, User, Building2, Banknote, Percent, Loader2 } from 'lucide-react';
import { useSimulator } from '../app/hooks/useSimulator';

export function Simulator() {
  const {
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
  } = useSimulator();

  if (loading) {
    return (
      <div className="min-h-screen bg-[#efefef] flex items-center justify-center">
        <div className="text-center">
          <Loader2 className="h-12 w-12 text-[#00a091] animate-spin mx-auto mb-4" />
          <p className="text-[#00353e]">Carregando dados...</p>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-[#efefef]">
      <div className="max-w-4xl mx-auto">
        {/* Header */}
        <div className="text-center rounded-b-xl shadow-sm bg-[#003641] p-8 mb-8">
          <div className="flex items-center justify-center gap-3">
            <Calculator className="h-10 w-10 text-[#00a091]" />
            <h1 className="text-3xl font-bold text-white">
              Simulador de credito
            </h1>
          </div>
        </div>

        <div className="grid md:grid-cols-2 gap-8">
          {/* Formulario */}
          <div className="bg-white rounded-xl shadow-sm p-6">
            <h2 className="text-xl font-semibold text-[#00353e] mb-6 flex items-center gap-2">
              <User className="h-5 w-5 text-[#00a091]" />
              Dados do cliente
            </h2>

            {/* Perfil */}
            <div className="mb-6">
              <label className="block text-sm font-medium text-[#00353e] mb-2">
                Perfil
              </label>
              <div className="grid grid-cols-2 gap-3">
                <button
                  onClick={() => setPersonType('PF')}
                  className={`p-3 rounded-lg border-2 transition-all text-gray-600 flex items-center gap-2 ${
                    personType === 'PF'
                      ? 'border-[#79BA43] bg-[#79BA43] text-white'
                      : 'border-gray-200 hover:border-gray-300'
                  }`}
                >
                  <User className="h-4 w-4" />
                  Pessoa fisica
                </button>
                <button
                  onClick={() => setPersonType('PJ')}
                  className={`p-3 rounded-lg border-2 transition-all text-gray-600 flex items-center gap-2 ${
                    personType === 'PJ'
                      ? 'border-[#B7CB33] bg-[#B7CB33] text-white'
                      : 'border-gray-200 hover:border-gray-300'
                  }`}
                >
                  <Building2 className="h-4 w-4" />
                  Pessoa juridica
                </button>
              </div>
            </div>

            {/* Modalidade */}
            {personType && (
              <div className="mb-6">
                <label className="block text-sm font-medium text-[#00353e] mb-2">
                  Modalidade
                </label>
                <select
                  value={modality}
                  onChange={(e) => setModality(e.target.value)}
                  className="w-full p-3 text-gray-600 border border-gray-300 rounded-lg focus:border-transparent"
                >
                  <option value="">Selecione a modalidade</option>
                  <option value="Pre-fixado">Pre-fixado</option>
                  <option value="Pos-fixado">Pos-fixado</option>
                </select>
              </div>
            )}

            {/* Produto */}
            {modality && (
              <div className="mb-6">
                <label className="block text-sm font-medium text-[#00353e] mb-2">
                  Produto
                </label>
                <select
                  value={product}
                  onChange={(e) => setProduct(e.target.value)}
                  className="w-full text-gray-600 p-3 border border-gray-300 rounded-lg focus:border-transparent"
                >
                  <option value="">Selecione o produto</option>
                  {getAvailableProducts().map(prod => (
                    <option key={prod} value={prod}>{prod}</option>
                  ))}
                </select>
              </div>
            )}

            {/* Renda */}
            <div className="mb-6">
              <label className="block text-sm font-medium text-[#00353e] mb-2">
                Renda mensal
              </label>
              <div className="relative">
                <Banknote className="absolute left-3 top-4 h-5 w-5 text-[#00353e]" />
                <input
                  type="text"
                  value={income}
                  onChange={handleIncomeChange}
                  placeholder="R$ 0,00"
                  className="w-full text-gray-600 pl-10 pr-4 py-3 border border-gray-300 rounded-lg focus:border-transparent"
                />
              </div>
            </div>
          </div>

          {/* Resultado */}
          <div className="bg-white rounded-xl shadow-sm p-6">
            <h2 className="text-xl font-semibold text-[#00353e] mb-6 flex items-center gap-2">
              <Percent className="h-5 w-5 text-[#00a091]" />
              Resultado
            </h2>
            <div className='mt-20'>
              {result ? (
              <div className="space-y-4">
                {result.error ? (
                  <div className="bg-red-50 border border-red-700 rounded-lg p-4">
                    <p className="text-red-700 font-medium">
                      {result.error}
                    </p>
                  </div>
                ) : (
                  <>
                    <div className={`p-3 rounded-lg border-2 transition-all ${
                    personType === 'PF'
                      ? 'border-[#79BA43] bg-white text-[#79BA43] rounded-lg p-4'
                      : 'border-[#B7CB33] bg-white text-[#B7CB33] rounded-lg p-4'
                  }`}>
                      <div className="text-sm font-medium mb-1">
                        Segmento
                      </div>
                      <div className="text-2xl font-bold">
                        {result.segment}
                      </div>
                      <div className="text-sm mt-1">
                        ({result.segmentCode})
                      </div>
                    </div>

                    <div className="bg-white border border-[#00a091] rounded-lg p-4">
                      <div className="text-sm text-[#00a091] font-medium mb-1">
                        Taxa personalizada
                      </div>
                      <div className="text-3xl font-bold text-[#00a091]">
                        {result.rate !== null ? (result.rate * 100).toFixed(2) : '--'}%
                      </div>
                      <div className="text-sm text-[#00a091] mt-1">
                        ao mes
                      </div>
                    </div>
                  </>
                )}
              </div>
            ) : (
              <div className="text-center py-12">
                <Calculator className="h-16 w-16 text-[#00a091] mx-auto mb-4" />
                <p className="text-[#00353e]">
                  Preencha os dados para ver o resultado da simulacao
                </p>
              </div>
            )}
            </div>
          </div>
        </div>

        {/* Informacoes adicionais */}
        <div className="mt-8 bg-white rounded-xl shadow-sm p-6">
          <h3 className="text-lg font-semibold text-[#00353e] mb-4">
            Como funciona a classificacao de segmentos?
          </h3>
          <div className="grid md:grid-cols-2 gap-6">
            <div>
              <h4 className="font-medium text-[#79BA43] mb-2">Pessoa fisica (PF)</h4>
              <ul className="space-y-1 text-sm text-[#00353e]">
                <li><strong>Basico (PF1):</strong> Renda anual ate R$ 2.000,00</li>
                <li><strong>Intermediario (PF2):</strong> Renda anual de R$ 2.001,00 a R$ 20.000,00</li>
                <li><strong>Premium (PF3):</strong> Renda anual de R$ 20.001,00 a R$ 200.000,00</li>
                <li><strong>Black (PF4):</strong> Renda anual acima de R$ 200.000,00</li>
              </ul>
            </div>
            <div>
              <h4 className="font-medium text-[#B7CB33] mb-2">Pessoa juridica (PJ)</h4>
              <ul className="space-y-1 text-sm text-[#00353e]">
                <li><strong>MEI (PJ1):</strong> Renda anual ate R$ 4.000,00</li>
                <li><strong>Empresarial (PJ2):</strong> Renda anual de R$ 4.001,00 a R$ 400.000,00</li>
                <li><strong>Corporativo (PJ3):</strong> Renda anual de R$ 400.001,00 a R$ 40.000.000,00</li>
                <li><strong>Enterprise (PJ4):</strong> Renda anual acima de R$ 40.000.000,00</li>
              </ul>
            </div>
          </div>
        </div>

        {/* Footer */}
        <div className="text-center mt-8 text-[#00353e] text-sm">
          <p>Feito por <a href="https://www.linkedin.com/in/fabriciosoares/" target="_blank" rel="noopener noreferrer" className="text-[#00a091] hover:underline">Fabricio Soares</a></p>
        </div>
      </div>
    </div>
  );
}