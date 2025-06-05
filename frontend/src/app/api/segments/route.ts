import { NextResponse } from 'next/server';
import { getConnection } from '@/lib/db';

export async function GET() {
  try {
    const pool = await getConnection();
    const result = await pool.request()
      .query('SELECT * FROM Segments ORDER BY PersonType, MinAnnualIncome');
    
    return NextResponse.json(result.recordset);
  } catch (error) {
    console.error('Erro ao buscar segmentos:', error);
    return NextResponse.json({ error: 'Erro ao buscar segmentos' }, { status: 500 });
  }
}