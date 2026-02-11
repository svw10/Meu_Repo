
import React from 'react';

export default function LandingPage() {
    return (
        <div className="min-h-screen flex flex-col items-center justify-center bg-gray-50 text-gray-900">
            <main className="flex flex-col items-center text-center px-4">
                <h1 className="text-5xl font-bold tracking-tight mb-6">
                    AprenderIA
                </h1>
                <p className="text-xl text-gray-600 max-w-2xl mb-8">
                    Plataforma de Aceleração Profissional em IA — B2P.
                    Potencialize sua carreira com agentes autônomos e workflows inteligentes.
                </p>
                <div className="flex gap-4">
                    <button className="px-6 py-3 bg-blue-600 text-white rounded-lg font-medium hover:bg-blue-700 transition-colors">
                        Começar Agora
                    </button>
                    <button className="px-6 py-3 bg-white text-gray-700 border border-gray-300 rounded-lg font-medium hover:bg-gray-50 transition-colors">
                        Saiba Mais
                    </button>
                </div>
            </main>
        </div>
    );
}
