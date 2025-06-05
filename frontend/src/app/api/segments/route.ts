import { NextResponse } from 'next/server';
import db from '@/lib/db';

export async function GET() {
  try {
    const segments = db.prepare('SELECT * FROM Segments ORDER BY PersonType, MinAnnualIncome').all();
    return NextResponse.json(segments);
  } catch (error) {
    console.error('Erro ao buscar segmentos:', error);
    return NextResponse.json({ error: 'Erro ao buscar segmentos' }, { status: 500 });
  }
}