name: ui-kit-saas
description: UI Kit Antigravity - Modo SAAS funcional. Dashboards, dados, eficiência.
version: 3.0.0
tags: [ui, design-system, saas, dashboard, functional, tanstack-table, react-hook-form, recharts]
---

# UI KIT ANTIGRAVITY SAAS v3.0 – COMPLETO

> **Filosofia**: O dashboard é uma **ferramenta**, não uma obra de arte. O usuário quer completar tarefas em tempo mínimo.  
> Este kit entrega componentes prontos para produção, com foco em performance, acessibilidade e experiência do usuário.

---

## 🎯 STACK OMEGA (Base Técnica)

Framework: Next.js 14+ (App Router)
Estilização: Tailwind CSS
Componentes Base: Shadcn UI (Radix UI + Tailwind)
Formulários: React Hook Form + Zod
Tabelas: TanStack Table v8
Gráficos: Recharts
Ícones: Lucide React
Motion: Framer Motion (apenas para micro-interações funcionais)
Fonte: Inter ou Geist
Gerenciamento de Estado: Zustand ou Context API (a critério)
```

---

## 🎨 DESIGN TOKENS – Fundação (revisados)

### Cores Semânticas (com suporte a modo escuro – opcional)

```css
:root {
  --background: 0 0% 100%;
  --foreground: 240 10% 3.9%;
  --primary: 199 89% 48%;
  --primary-foreground: 0 0% 100%;
  --secondary: 240 4.8% 95.9%;
  --secondary-foreground: 240 5.9% 10%;
  --muted: 240 4.8% 95.9%;
  --muted-foreground: 240 3.8% 46.1%;
  --accent: 240 4.8% 95.9%;
  --accent-foreground: 240 5.9% 10%;
  --destructive: 0 84.2% 60.2%;
  --destructive-foreground: 0 0% 98%;
  --border: 240 5.9% 90%;
  --input: 240 5.9% 90%;
  --ring: 199 89% 48%;
  --success: 160 84% 39%;
  --warning: 32 95% 44%;
  --error: 0 84% 60%;
  --info: 199 89% 48%;
}
```

### Tipografia

```css
/* Tailwind config extension */
.font-sans {
  font-family: var(--font-inter), system-ui, sans-serif;
}
```

| Elemento | Tamanho (rem) | Peso | Line-height | Uso |
|----------|---------------|------|-------------|-----|
| `display` | 2.5rem (40px) | 700 | 1.2 | Títulos de página |
| `h1` | 1.875rem (30px) | 600 | 1.3 | Page title |
| `h2` | 1.5rem (24px) | 600 | 1.4 | Section title |
| `h3` | 1.25rem (20px) | 600 | 1.4 | Card title |
| `body` | 1rem (16px) | 400 | 1.6 | Texto padrão |
| `body-sm` | 0.875rem (14px) | 400 | 1.5 | Texto secundário |
| `label` | 0.875rem (14px) | 500 | 1.4 | Labels de formulário |
| `data-lg` | 1.5rem (24px) | 600 | 1.3 | Números de KPI |
| `data` | 1rem (16px) | 500 | 1.4 | Dados em tabelas |
| `small` | 0.75rem (12px) | 400 | 1.4 | Metadados |

### Espaçamento Funcional (escala de 4px)

| Token | Valor | Uso |
|-------|-------|-----|
| `space-1` | 0.25rem (4px) | Gaps mínimos |
| `space-2` | 0.5rem (8px) | Gaps pequenos entre elementos |
| `space-3` | 0.75rem (12px) | Padding interno de inputs |
| `space-4` | 1rem (16px) | Padding de cards, gap entre seções |
| `space-6` | 1.5rem (24px) | Margens entre blocos |
| `space-8` | 2rem (32px) | Padding de containers principais |
| `space-12` | 3rem (48px) | Separação de grandes áreas |

### Sombras (para elevação funcional)

```css
/* Tailwind shadows */
.shadow-card {
  box-shadow: 0 1px 3px 0 rgb(0 0 0 / 0.05), 0 1px 2px -1px rgb(0 0 0 / 0.05);
}
.shadow-dropdown {
  box-shadow: 0 4px 6px -1px rgb(0 0 0 / 0.1), 0 2px 4px -2px rgb(0 0 0 / 0.1);
}
.shadow-modal {
  box-shadow: 0 10px 15px -3px rgb(0 0 0 / 0.1), 0 4px 6px -4px rgb(0 0 0 / 0.1);
}
```

---

## ⚡ PRINCÍPIOS FUNCIONAIS APLICADOS

### 1. Velocidade Percebida (tempos de transição)

| Elemento | Duração | Curva | Observação |
|----------|---------|-------|------------|
| Page transition (fade) | 0.2s | ease-out | Usar `opacity` |
| Hover em linha de tabela | 0.1s | linear | Mudança de cor de fundo |
| Hover em botão | 0.1s | linear | Escala ou cor |
| Abertura de modal | 0.2s | ease-out | Scale + fade |
| Dropdown | 0.15s | ease-out | Height + opacity |
| Skeleton pulse | 1.5s | infinite | `animate-pulse` do Tailwind |

### 2. Densidade Informacional

- **Padding interno mínimo**: `p-3` (12px) em células de tabela, `p-4` (16px) em cards.
- **White space estratégico**: usado para separar seções, não dentro de componentes densos.
- **Hierarquia por cor e peso**: dados importantes em negrito ou com cor primária.

### 3. Padrões Consistentes

- Todos os botões de ação primária usam `variant="default"` do Shadcn.
- Formulários sempre com `space-y-4` entre campos.
- Mensagens de erro posicionadas abaixo do campo (input error).
- Tabelas com header fixo e sombra sutil ao rolar.

---

## 🧩 LAYOUTS PADRÃO – App Shell

### Estrutura Base (com Sidebar responsiva)

```tsx
// app/layout.tsx (ou componente de layout interno)
export default function DashboardLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <div className="flex h-screen">
      <Sidebar />
      <div className="flex flex-1 flex-col">
        <Header />
        <main className="flex-1 overflow-y-auto p-6">{children}</main>
      </div>
    </div>
  );
}
```

### Sidebar (colapsável)

```tsx
// components/sidebar.tsx
'use client';

import { useState } from 'react';
import { cn } from '@/lib/utils';
import { Button } from '@/components/ui/button';
import { ChevronLeft, ChevronRight, LayoutDashboard, Users, Settings } from 'lucide-react';
import Link from 'next/link';

const navItems = [
  { icon: LayoutDashboard, label: 'Dashboard', href: '/' },
  { icon: Users, label: 'Usuários', href: '/users' },
  { icon: Settings, label: 'Configurações', href: '/settings' },
];

export function Sidebar() {
  const [collapsed, setCollapsed] = useState(false);

  return (
    <aside
      className={cn(
        'relative flex flex-col border-r bg-background transition-all duration-200',
        collapsed ? 'w-16' : 'w-64'
      )}
    >
      <div className="flex h-16 items-center justify-between px-4">
        {!collapsed && <span className="font-bold">Antigravity</span>}
        <Button
          variant="ghost"
          size="icon"
          onClick={() => setCollapsed(!collapsed)}
          className="ml-auto"
        >
          {collapsed ? <ChevronRight size={16} /> : <ChevronLeft size={16} />}
        </Button>
      </div>
      <nav className="flex-1 space-y-1 p-2">
        {navItems.map((item) => (
          <Link
            key={item.href}
            href={item.href}
            className={cn(
              'flex items-center gap-3 rounded-md px-3 py-2 text-sm transition-colors hover:bg-muted',
              collapsed && 'justify-center'
            )}
          >
            <item.icon size={18} />
            {!collapsed && <span>{item.label}</span>}
          </Link>
        ))}
      </nav>
    </aside>
  );
}
```

### Header (com perfil e notificações)

```tsx
// components/header.tsx
import { Button } from '@/components/ui/button';
import { Bell, Search } from 'lucide-react';
import { Input } from '@/components/ui/input';
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuLabel,
  DropdownMenuSeparator,
  DropdownMenuTrigger,
} from '@/components/ui/dropdown-menu';
import { Avatar, AvatarFallback, AvatarImage } from '@/components/ui/avatar';

export function Header() {
  return (
    <header className="flex h-16 items-center justify-between border-b bg-background px-6">
      <div className="flex items-center gap-4">
        <div className="relative">
          <Search className="absolute left-2.5 top-2.5 h-4 w-4 text-muted-foreground" />
          <Input placeholder="Buscar..." className="w-64 pl-8" />
        </div>
      </div>
      <div className="flex items-center gap-2">
        <Button variant="ghost" size="icon">
          <Bell size={18} />
        </Button>
        <DropdownMenu>
          <DropdownMenuTrigger asChild>
            <Button variant="ghost" className="relative h-8 w-8 rounded-full">
              <Avatar className="h-8 w-8">
                <AvatarImage src="/avatars/user.png" alt="Usuário" />
                <AvatarFallback>U</AvatarFallback>
              </Avatar>
            </Button>
          </DropdownMenuTrigger>
          <DropdownMenuContent align="end">
            <DropdownMenuLabel>Minha Conta</DropdownMenuLabel>
            <DropdownMenuSeparator />
            <DropdownMenuItem>Perfil</DropdownMenuItem>
            <DropdownMenuItem>Configurações</DropdownMenuItem>
            <DropdownMenuSeparator />
            <DropdownMenuItem>Sair</DropdownMenuItem>
          </DropdownMenuContent>
        </DropdownMenu>
      </div>
    </header>
  );
}
```

---

## 📊 DATA TABLE PRO (TanStack Table + Shadcn)

Exemplo completo com ordenação, filtro global, paginação, seleção de linhas e ações em lote.

```tsx
// components/data-table.tsx
'use client';

import * as React from 'react';
import {
  ColumnDef,
  ColumnFiltersState,
  SortingState,
  VisibilityState,
  flexRender,
  getCoreRowModel,
  getFilteredRowModel,
  getPaginationRowModel,
  getSortedRowModel,
  useReactTable,
} from '@tanstack/react-table';
import { ArrowUpDown, ChevronDown, MoreHorizontal } from 'lucide-react';

import { Button } from '@/components/ui/button';
import { Checkbox } from '@/components/ui/checkbox';
import {
  DropdownMenu,
  DropdownMenuCheckboxItem,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuLabel,
  DropdownMenuSeparator,
  DropdownMenuTrigger,
} from '@/components/ui/dropdown-menu';
import { Input } from '@/components/ui/input';
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from '@/components/ui/table';
import { Badge } from '@/components/ui/badge';

export type User = {
  id: string;
  name: string;
  email: string;
  status: 'active' | 'inactive' | 'pending';
  role: string;
  lastLogin: string;
};

export const columns: ColumnDef<User>[] = [
  {
    id: 'select',
    header: ({ table }) => (
      <Checkbox
        checked={table.getIsAllPageRowsSelected()}
        onCheckedChange={(value) => table.toggleAllPageRowsSelected(!!value)}
        aria-label="Select all"
      />
    ),
    cell: ({ row }) => (
      <Checkbox
        checked={row.getIsSelected()}
        onCheckedChange={(value) => row.toggleSelected(!!value)}
        aria-label="Select row"
      />
    ),
    enableSorting: false,
    enableHiding: false,
  },
  {
    accessorKey: 'name',
    header: ({ column }) => (
      <Button
        variant="ghost"
        onClick={() => column.toggleSorting(column.getIsSorted() === 'asc')}
      >
        Nome
        <ArrowUpDown className="ml-2 h-4 w-4" />
      </Button>
    ),
    cell: ({ row }) => <div className="font-medium">{row.getValue('name')}</div>,
  },
  {
    accessorKey: 'email',
    header: 'Email',
  },
  {
    accessorKey: 'status',
    header: 'Status',
    cell: ({ row }) => {
      const status = row.getValue('status') as string;
      return (
        <Badge
          variant={
            status === 'active'
              ? 'success'
              : status === 'inactive'
              ? 'secondary'
              : 'warning'
          }
        >
          {status}
        </Badge>
      );
    },
  },
  {
    accessorKey: 'role',
    header: 'Função',
  },
  {
    accessorKey: 'lastLogin',
    header: 'Último acesso',
    cell: ({ row }) => new Date(row.getValue('lastLogin')).toLocaleDateString('pt-BR'),
  },
  {
    id: 'actions',
    enableHiding: false,
    cell: ({ row }) => {
      const user = row.original;
      return (
        <DropdownMenu>
          <DropdownMenuTrigger asChild>
            <Button variant="ghost" className="h-8 w-8 p-0">
              <span className="sr-only">Abrir menu</span>
              <MoreHorizontal className="h-4 w-4" />
            </Button>
          </DropdownMenuTrigger>
          <DropdownMenuContent align="end">
            <DropdownMenuLabel>Ações</DropdownMenuLabel>
            <DropdownMenuItem onClick={() => navigator.clipboard.writeText(user.id)}>
              Copiar ID
            </DropdownMenuItem>
            <DropdownMenuSeparator />
            <DropdownMenuItem>Editar</DropdownMenuItem>
            <DropdownMenuItem className="text-destructive">Excluir</DropdownMenuItem>
          </DropdownMenuContent>
        </DropdownMenu>
      );
    },
  },
];

export function DataTableDemo({ data }: { data: User[] }) {
  const [sorting, setSorting] = React.useState<SortingState>([]);
  const [columnFilters, setColumnFilters] = React.useState<ColumnFiltersState>([]);
  const [columnVisibility, setColumnVisibility] = React.useState<VisibilityState>({});
  const [rowSelection, setRowSelection] = React.useState({});

  const table = useReactTable({
    data,
    columns,
    onSortingChange: setSorting,
    onColumnFiltersChange: setColumnFilters,
    getCoreRowModel: getCoreRowModel(),
    getPaginationRowModel: getPaginationRowModel(),
    getSortedRowModel: getSortedRowModel(),
    getFilteredRowModel: getFilteredRowModel(),
    onColumnVisibilityChange: setColumnVisibility,
    onRowSelectionChange: setRowSelection,
    state: {
      sorting,
      columnFilters,
      columnVisibility,
      rowSelection,
    },
  });

  return (
    <div className="w-full">
      <div className="flex items-center py-4">
        <Input
          placeholder="Filtrar por email..."
          value={(table.getColumn('email')?.getFilterValue() as string) ?? ''}
          onChange={(event) =>
            table.getColumn('email')?.setFilterValue(event.target.value)
          }
          className="max-w-sm"
        />
        <DropdownMenu>
          <DropdownMenuTrigger asChild>
            <Button variant="outline" className="ml-auto">
              Colunas <ChevronDown className="ml-2 h-4 w-4" />
            </Button>
          </DropdownMenuTrigger>
          <DropdownMenuContent align="end">
            {table
              .getAllColumns()
              .filter((column) => column.getCanHide())
              .map((column) => (
                <DropdownMenuCheckboxItem
                  key={column.id}
                  className="capitalize"
                  checked={column.getIsVisible()}
                  onCheckedChange={(value) => column.toggleVisibility(!!value)}
                >
                  {column.id}
                </DropdownMenuCheckboxItem>
              ))}
          </DropdownMenuContent>
        </DropdownMenu>
      </div>
      <div className="rounded-md border">
        <Table>
          <TableHeader>
            {table.getHeaderGroups().map((headerGroup) => (
              <TableRow key={headerGroup.id}>
                {headerGroup.headers.map((header) => (
                  <TableHead key={header.id}>
                    {header.isPlaceholder
                      ? null
                      : flexRender(header.column.columnDef.header, header.getContext())}
                  </TableHead>
                ))}
              </TableRow>
            ))}
          </TableHeader>
          <TableBody>
            {table.getRowModel().rows?.length ? (
              table.getRowModel().rows.map((row) => (
                <TableRow
                  key={row.id}
                  data-state={row.getIsSelected() && 'selected'}
                  className="hover:bg-muted/50 transition-colors duration-100"
                >
                  {row.getVisibleCells().map((cell) => (
                    <TableCell key={cell.id}>
                      {flexRender(cell.column.columnDef.cell, cell.getContext())}
                    </TableCell>
                  ))}
                </TableRow>
              ))
            ) : (
              <TableRow>
                <TableCell colSpan={columns.length} className="h-24 text-center">
                  Nenhum resultado.
                </TableCell>
              </TableRow>
            )}
          </TableBody>
        </Table>
      </div>
      <div className="flex items-center justify-end space-x-2 py-4">
        <div className="flex-1 text-sm text-muted-foreground">
          {table.getFilteredSelectedRowModel().rows.length} de{' '}
          {table.getFilteredRowModel().rows.length} linha(s) selecionada(s).
        </div>
        <div className="space-x-2">
          <Button
            variant="outline"
            size="sm"
            onClick={() => table.previousPage()}
            disabled={!table.getCanPreviousPage()}
          >
            Anterior
          </Button>
          <Button
            variant="outline"
            size="sm"
            onClick={() => table.nextPage()}
            disabled={!table.getCanNextPage()}
          >
            Próxima
          </Button>
        </div>
      </div>
    </div>
  );
}
```

### Ações em Lote (exemplo)

```tsx
// componente acima da tabela
{table.getFilteredSelectedRowModel().rows.length > 0 && (
  <div className="flex items-center gap-2">
    <span className="text-sm text-muted-foreground">
      {table.getFilteredSelectedRowModel().rows.length} selecionados
    </span>
    <Button variant="destructive" size="sm">
      Excluir selecionados
    </Button>
    <Button variant="outline" size="sm">
      Alterar status
    </Button>
  </div>
)}
```

---

## 📝 FORM SYSTEM – React Hook Form + Zod

### Exemplo de formulário com validação e campos customizados

```tsx
// components/user-form.tsx
'use client';

import { zodResolver } from '@hookform/resolvers/zod';
import { useForm } from 'react-hook-form';
import * as z from 'zod';
import { Button } from '@/components/ui/button';
import {
  Form,
  FormControl,
  FormDescription,
  FormField,
  FormItem,
  FormLabel,
  FormMessage,
} from '@/components/ui/form';
import { Input } from '@/components/ui/input';
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from '@/components/ui/select';
import { toast } from '@/components/ui/use-toast';

const formSchema = z.object({
  name: z.string().min(2, {
    message: 'Nome deve ter pelo menos 2 caracteres.',
  }),
  email: z.string().email({
    message: 'Email inválido.',
  }),
  role: z.enum(['admin', 'user', 'guest'], {
    required_error: 'Selecione uma função.',
  }),
});

export function UserForm() {
  const form = useForm<z.infer<typeof formSchema>>({
    resolver: zodResolver(formSchema),
    defaultValues: {
      name: '',
      email: '',
    },
  });

  function onSubmit(values: z.infer<typeof formSchema>) {
    toast({
      title: 'Usuário criado',
      description: `${values.name} (${values.email}) - ${values.role}`,
    });
  }

  return (
    <Form {...form}>
      <form onSubmit={form.handleSubmit(onSubmit)} className="space-y-6">
        <FormField
          control={form.control}
          name="name"
          render={({ field }) => (
            <FormItem>
              <FormLabel>Nome</FormLabel>
              <FormControl>
                <Input placeholder="João Silva" {...field} />
              </FormControl>
              <FormDescription>Nome completo do usuário.</FormDescription>
              <FormMessage />
            </FormItem>
          )}
        />
        <FormField
          control={form.control}
          name="email"
          render={({ field }) => (
            <FormItem>
              <FormLabel>Email</FormLabel>
              <FormControl>
                <Input placeholder="joao@exemplo.com" {...field} />
              </FormControl>
              <FormMessage />
            </FormItem>
          )}
        />
        <FormField
          control={form.control}
          name="role"
          render={({ field }) => (
            <FormItem>
              <FormLabel>Função</FormLabel>
              <Select onValueChange={field.onChange} defaultValue={field.value}>
                <FormControl>
                  <SelectTrigger>
                    <SelectValue placeholder="Selecione uma função" />
                  </SelectTrigger>
                </FormControl>
                <SelectContent>
                  <SelectItem value="admin">Administrador</SelectItem>
                  <SelectItem value="user">Usuário</SelectItem>
                  <SelectItem value="guest">Convidado</SelectItem>
                </SelectContent>
              </Select>
              <FormMessage />
            </FormItem>
          )}
        />
        <Button type="submit">Salvar</Button>
      </form>
    </Form>
  );
}
```

### Multi-step Form (layout de onboarding)

```tsx
// components/multi-step-form.tsx – estrutura simplificada
'use client';

import { useState } from 'react';
import { Button } from '@/components/ui/button';
import { Progress } from '@/components/ui/progress';

const steps = ['Informações', 'Endereço', 'Pagamento'];

export function MultiStepForm() {
  const [currentStep, setCurrentStep] = useState(0);

  const next = () => setCurrentStep((prev) => Math.min(prev + 1, steps.length - 1));
  const prev = () => setCurrentStep((prev) => Math.max(prev - 1, 0));

  return (
    <div className="space-y-6">
      <div className="space-y-2">
        <div className="flex justify-between text-sm">
          {steps.map((step, index) => (
            <span key={step} className={index <= currentStep ? 'text-primary' : 'text-muted'}>
              {step}
            </span>
          ))}
        </div>
        <Progress value={((currentStep + 1) / steps.length) * 100} />
      </div>
      <div>
        {currentStep === 0 && <div>Formulário etapa 1</div>}
        {currentStep === 1 && <div>Formulário etapa 2</div>}
        {currentStep === 2 && <div>Formulário etapa 3</div>}
      </div>
      <div className="flex justify-between">
        <Button variant="outline" onClick={prev} disabled={currentStep === 0}>
          Anterior
        </Button>
        <Button onClick={next} disabled={currentStep === steps.length - 1}>
          Próximo
        </Button>
      </div>
    </div>
  );
}
```

---

## 📈 CHART COMPONENTS – Recharts

### Exemplo de gráfico de linha com dados mockados

```tsx
// components/line-chart.tsx
'use client';

import {
  LineChart,
  Line,
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip,
  ResponsiveContainer,
} from 'recharts';

const data = [
  { name: 'Jan', vendas: 4000 },
  { name: 'Fev', vendas: 3000 },
  { name: 'Mar', vendas: 5000 },
  { name: 'Abr', vendas: 4500 },
  { name: 'Mai', vendas: 6000 },
  { name: 'Jun', vendas: 5500 },
];

export function SalesChart() {
  return (
    <ResponsiveContainer width="100%" height={300}>
      <LineChart data={data}>
        <CartesianGrid strokeDasharray="3 3" />
        <XAxis dataKey="name" />
        <YAxis />
        <Tooltip />
        <Line type="monotone" dataKey="vendas" stroke="#0ea5e9" strokeWidth={2} />
      </LineChart>
    </ResponsiveContainer>
  );
}
```

### Bar Chart, Area Chart, Pie Chart (exemplos rápidos)

```tsx
// BarChart, AreaChart, PieChart – componentes similares
// Importe Bar, BarChart, Area, AreaChart, Pie, PieChart, Cell, etc.
```

### Card de KPI com Sparkline (mini gráfico)

```tsx
// components/kpi-card.tsx
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { TrendingUp, TrendingDown } from 'lucide-react';
import { Area, AreaChart, ResponsiveContainer } from 'recharts';

const sparklineData = [10, 15, 8, 12, 20, 18, 25];

export function KpiCard({ title, value, trend }: { title: string; value: string; trend: number }) {
  return (
    <Card>
      <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
        <CardTitle className="text-sm font-medium">{title}</CardTitle>
        {trend > 0 ? (
          <TrendingUp className="h-4 w-4 text-success" />
        ) : (
          <TrendingDown className="h-4 w-4 text-destructive" />
        )}
      </CardHeader>
      <CardContent>
        <div className="text-2xl font-bold">{value}</div>
        <p className="text-xs text-muted-foreground">
          {trend > 0 ? '+' : ''}
          {trend}% em relação ao mês passado
        </p>
        <div className="mt-2 h-8 w-full">
          <ResponsiveContainer width="100%" height="100%">
            <AreaChart data={sparklineData.map((val, i) => ({ value: val }))}>
              <Area
                type="monotone"
                dataKey="value"
                stroke="#0ea5e9"
                fill="#0ea5e9"
                fillOpacity={0.2}
                strokeWidth={1.5}
              />
            </AreaChart>
          </ResponsiveContainer>
        </div>
      </CardContent>
    </Card>
  );
}
```

---

## 🔔 FEEDBACK COMPONENTS

### Toast System (Shadcn)

```tsx
// Em qualquer lugar
import { toast } from '@/components/ui/use-toast';

toast({
  title: 'Sucesso!',
  description: 'Operação realizada com sucesso.',
  variant: 'success', // ou 'destructive' para erro
});
```

### Dialog de Confirmação

```tsx
// components/confirm-dialog.tsx
import {
  AlertDialog,
  AlertDialogAction,
  AlertDialogCancel,
  AlertDialogContent,
  AlertDialogDescription,
  AlertDialogFooter,
  AlertDialogHeader,
  AlertDialogTitle,
} from '@/components/ui/alert-dialog';

export function ConfirmDialog({
  open,
  onOpenChange,
  onConfirm,
  title,
  description,
}: {
  open: boolean;
  onOpenChange: (open: boolean) => void;
  onConfirm: () => void;
  title: string;
  description: string;
}) {
  return (
    <AlertDialog open={open} onOpenChange={onOpenChange}>
      <AlertDialogContent>
        <AlertDialogHeader>
          <AlertDialogTitle>{title}</AlertDialogTitle>
          <AlertDialogDescription>{description}</AlertDialogDescription>
        </AlertDialogHeader>
        <AlertDialogFooter>
          <AlertDialogCancel>Cancelar</AlertDialogCancel>
          <AlertDialogAction onClick={onConfirm}>Confirmar</AlertDialogAction>
        </AlertDialogFooter>
      </AlertDialogContent>
    </AlertDialog>
  );
}
```

### Empty State

```tsx
// components/empty-state.tsx
import { Button } from '@/components/ui/button';
import { Inbox } from 'lucide-react';

export function EmptyState({
  title,
  description,
  actionLabel,
  onAction,
}: {
  title: string;
  description: string;
  actionLabel?: string;
  onAction?: () => void;
}) {
  return (
    <div className="flex flex-col items-center justify-center rounded-lg border border-dashed p-8 text-center">
      <Inbox className="h-12 w-12 text-muted-foreground" />
      <h3 className="mt-4 text-lg font-semibold">{title}</h3>
      <p className="mt-2 text-sm text-muted-foreground">{description}</p>
      {actionLabel && onAction && (
        <Button onClick={onAction} className="mt-4">
          {actionLabel}
        </Button>
      )}
    </div>
  );
}
```

### Skeleton Loaders (específicos)

```tsx
// components/skeleton-table.tsx
import { Skeleton } from '@/components/ui/skeleton';

export function SkeletonTable() {
  return (
    <div className="space-y-3">
      <div className="flex items-center space-x-4">
        <Skeleton className="h-4 w-[250px]" />
        <Skeleton className="h-4 w-[200px]" />
      </div>
      {Array.from({ length: 5 }).map((_, i) => (
        <Skeleton key={i} className="h-12 w-full" />
      ))}
    </div>
  );
}
```

---

## 🧭 NAVIGATION PATTERNS

### Breadcrumbs

```tsx
// components/breadcrumbs.tsx
import { ChevronRight, Home } from 'lucide-react';
import Link from 'next/link';

export function Breadcrumbs({ items }: { items: { label: string; href?: string }[] }) {
  return (
    <nav className="flex items-center space-x-1 text-sm text-muted-foreground">
      <Link href="/" className="hover:text-foreground">
        <Home size={14} />
      </Link>
      {items.map((item, index) => (
        <div key={index} className="flex items-center space-x-1">
          <ChevronRight size={14} />
          {item.href ? (
            <Link href={item.href} className="hover:text-foreground">
              {item.label}
            </Link>
          ) : (
            <span className="text-foreground">{item.label}</span>
          )}
        </div>
      ))}
    </nav>
  );
}
```

### Command Palette (cmd+k) – integração com `cmdk`

```tsx
// components/command-menu.tsx
'use client';

import * as React from 'react';
import { Command } from 'cmdk';
import { Dialog, DialogContent } from '@/components/ui/dialog';
import { Button } from '@/components/ui/button';
import { Search } from 'lucide-react';

export function CommandMenu() {
  const [open, setOpen] = React.useState(false);

  React.useEffect(() => {
    const down = (e: KeyboardEvent) => {
      if (e.key === 'k' && (e.metaKey || e.ctrlKey)) {
        e.preventDefault();
        setOpen((open) => !open);
      }
    };
    document.addEventListener('keydown', down);
    return () => document.removeEventListener('keydown', down);
  }, []);

  return (
    <>
      <Button variant="outline" className="relative h-9 w-9 p-0 xl:w-60 xl:justify-start xl:px-3 xl:py-2" onClick={() => setOpen(true)}>
        <Search className="h-4 w-4 xl:mr-2" />
        <span className="hidden xl:inline-flex">Buscar...</span>
        <kbd className="pointer-events-none absolute right-1.5 top-2 hidden h-5 select-none items-center gap-1 rounded border bg-muted px-1.5 font-mono text-[10px] font-medium opacity-100 xl:flex">
          <span className="text-xs">⌘</span>K
        </kbd>
      </Button>
      <Dialog open={open} onOpenChange={setOpen}>
        <DialogContent className="overflow-hidden p-0">
          <Command className="[&_[cmdk-group-heading]]:px-2 [&_[cmdk-group-heading]]:font-medium [&_[cmdk-group-heading]]:text-muted-foreground [&_[cmdk-group]:not([hidden])_~[cmdk-group]]:pt-0 [&_[cmdk-group]]:px-2 [&_[cmdk-input-wrapper]_svg]:h-5 [&_[cmdk-input-wrapper]_svg]:w-5 [&_[cmdk-input]]:h-12 [&_[cmdk-item]]:px-2 [&_[cmdk-item]]:py-3 [&_[cmdk-item]_svg]:h-5 [&_[cmdk-item]_svg]:w-5">
            <Command.Input placeholder="Digite um comando ou busca..." />
            <Command.List>
              <Command.Empty>Nenhum resultado encontrado.</Command.Empty>
              <Command.Group heading="Sugestões">
                <Command.Item>Dashboard</Command.Item>
                <Command.Item>Usuários</Command.Item>
                <Command.Item>Configurações</Command.Item>
              </Command.Group>
            </Command.List>
          </Command>
        </DialogContent>
      </Dialog>
    </>
  );
}
```

---

## ⚙️ SETTINGS PATTERN (Páginas de Configuração)

Layout típico com abas (tabs) para organizar seções.

```tsx
// app/settings/page.tsx
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/components/ui/tabs';
import { ProfileForm } from './profile-form';
import { AccountForm } from './account-form';
import { NotificationsForm } from './notifications-form';

export default function SettingsPage() {
  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-2xl font-bold">Configurações</h1>
        <p className="text-muted-foreground">Gerencie as preferências da sua conta.</p>
      </div>
      <Tabs defaultValue="profile" className="space-y-4">
        <TabsList>
          <TabsTrigger value="profile">Perfil</TabsTrigger>
          <TabsTrigger value="account">Conta</TabsTrigger>
          <TabsTrigger value="notifications">Notificações</TabsTrigger>
        </TabsList>
        <TabsContent value="profile" className="space-y-4">
          <ProfileForm />
        </TabsContent>
        <TabsContent value="account" className="space-y-4">
          <AccountForm />
        </TabsContent>
        <TabsContent value="notifications" className="space-y-4">
          <NotificationsForm />
        </TabsContent>
      </Tabs>
    </div>
  );
}
```

---

## 🚀 ONBOARDING FLOW

### Checklist interativo

```tsx
// components/onboarding-checklist.tsx
'use client';

import { useState } from 'react';
import { Checkbox } from '@/components/ui/checkbox';
import { Button } from '@/components/ui/button';
import { Progress } from '@/components/ui/progress';

const steps = [
  { id: 'profile', label: 'Completar perfil', completed: false },
  { id: 'team', label: 'Convidar membros da equipe', completed: false },
  { id: 'integrations', label: 'Conectar integrações', completed: false },
  { id: 'billing', label: 'Configurar faturamento', completed: false },
];

export function OnboardingChecklist() {
  const [items, setItems] = useState(steps);

  const toggle = (id: string) => {
    setItems((prev) =>
      prev.map((item) =>
        item.id === id ? { ...item, completed: !item.completed } : item
      )
    );
  };

  const progress = (items.filter((i) => i.completed).length / items.length) * 100;

  return (
    <div className="space-y-4 rounded-lg border p-4">
      <div className="flex items-center justify-between">
        <h3 className="font-semibold">Comece por aqui</h3>
        <span className="text-sm text-muted-foreground">
          {items.filter((i) => i.completed).length}/{items.length} concluídos
        </span>
      </div>
      <Progress value={progress} />
      <div className="space-y-2">
        {items.map((item) => (
          <div key={item.id} className="flex items-center space-x-2">
            <Checkbox
              id={item.id}
              checked={item.completed}
              onCheckedChange={() => toggle(item.id)}
            />
            <label htmlFor={item.id} className="text-sm">
              {item.label}
            </label>
          </div>
        ))}
      </div>
      <Button size="sm" className="w-full">
        Ir para o próximo passo
      </Button>
    </div>
  );
}
```

### Tooltips de orientação (com Radix UI)

```tsx
import {
  Tooltip,
  TooltipContent,
  TooltipProvider,
  TooltipTrigger,
} from '@/components/ui/tooltip';

<TooltipProvider>
  <Tooltip>
    <TooltipTrigger asChild>
      <Button variant="ghost">?</Button>
    </TooltipTrigger>
    <TooltipContent>
      <p>Clique aqui para ajuda</p>
    </TooltipContent>
  </Tooltip>
</TooltipProvider>
```

---

## ♿ ACESSIBILIDADE

### Padrões ARIA essenciais

- **Botões**: sempre com `aria-label` quando ícone sem texto.
- **Tabelas**: `aria-sort` nas colunas ordenáveis.
- **Modais**: foco preso dentro do modal, `aria-labelledby` e `aria-describedby`.
- **Formulários**: `aria-invalid` em campos com erro.
- **Dropdowns**: `aria-expanded` e `aria-haspopup`.

Exemplo de botão de ícone acessível:

```tsx
<Button variant="ghost" size="icon" aria-label="Notificações">
  <Bell size={18} />
</Button>
```

### Navegação por teclado

- Todas as ações devem ser acessíveis via Tab e Enter/Space.
- Dropdowns com setas para navegar.
- Modais fechados com Escape.

---

## 🔄 REAL-TIME & OTIMISTIC UPDATES (exemplo com Zustand + React Query)

```tsx
// Exemplo de mutação otimista com React Query
import { useMutation, useQueryClient } from '@tanstack/react-query';

function useUpdateUser() {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: (updatedUser) => api.updateUser(updatedUser),
    onMutate: async (updatedUser) => {
      await queryClient.cancelQueries(['users']);
      const previousUsers = queryClient.getQueryData(['users']);
      queryClient.setQueryData(['users'], (old) =>
        old.map((user) => (user.id === updatedUser.id ? updatedUser : user))
      );
      return { previousUsers };
    },
    onError: (err, updatedUser, context) => {
      queryClient.setQueryData(['users'], context.previousUsers);
      toast({
        title: 'Erro',
        description: 'Não foi possível atualizar o usuário.',
        variant: 'destructive',
      });
    },
    onSettled: () => {
      queryClient.invalidateQueries(['users']);
    },
  });
}
```

---

## 🎬 MOTION FUNCIONAL (Framer Motion)

### Presets (já definidos, mas refinados)

```tsx
import { motion } from 'framer-motion';

const fadeInOut = {
  initial: { opacity: 0 },
  animate: { opacity: 1, transition: { duration: 0.2 } },
  exit: { opacity: 0, transition: { duration: 0.15 } },
};

const slideInRight = {
  initial: { x: 20, opacity: 0 },
  animate: { x: 0, opacity: 1, transition: { duration: 0.2 } },
  exit: { x: -20, opacity: 0, transition: { duration: 0.15 } },
};

// Uso em página
<motion.div variants={fadeInOut} initial="initial" animate="animate" exit="exit">
  {children}
</motion.div>
```

### Shake de erro (pequeno)

```tsx
const shakeVariants = {
  shake: {
    x: [0, -5, 5, -5, 5, 0],
    transition: { duration: 0.3 },
  },
};

<motion.div variants={shakeVariants} animate="shake">
  {/* conteúdo com erro */}
</motion.div>
```

---

## 🚫 PROIBIDO EM SAAS (reforçado)

| Proibido | Motivo | Alternativa |
|----------|--------|-------------|
| Parallax scroll | Distração, sem função utilitária | Scroll nativo |
| Animações de entrada longas (>0.3s) | Atrasam o usuário | Fade rápido (0.2s) |
| Efeitos 3D, rotações | Overhead de performance, sem ganho | Flat design |
| Glassmorphism excessivo | Dificulta leitura de dados | Fundos sólidos, bordas suaves |
| Cores vibrantes em fundos | Cansa visual | Paleta neutra com acentos pontuais |
| Spinners infinitos sem feedback | Frustrante | Skeletons imediatos |
| Modais que não fecham com Escape | Quebra expectativa | Sempre implementar fechamento |

---

## 📁 ESTRUTURA DE ARQUIVOS (recomendada)

```
Ui_Kit_Saas/
├── 00_fundacao/
│   ├── design_tokens.md
│   ├── tailwind_config.md
│   └── shadcn_base.md
├── 01_layout/
│   ├── app_shell.md
│   ├── sidebar.md
│   ├── header.md
│   └── bento_grid.md
├── 02_componentes/
│   ├── data_table_pro.md
│   ├── forms_avancados.md
│   ├── charts.md
│   ├── feedback.md
│   ├── navigation.md
│   └── command_palette.md
├── 03_padroes/
│   ├── settings_page.md
│   ├── onboarding_flow.md
│   └── list_filter.md
├── 04_motion/
│   └── motion_functional.md
├── 05_acessibilidade/
│   └── a11y_patterns.md
└── INDEX.md (este arquivo)
```

---

## 🔗 RELACIONADOS

- **Landing Page**: `ui-kit-landing.md` (modo emocional, storytelling)
- **Motion Avançado**: `motion-advanced-utils.md` (para uso moderado em SAAS)

---

> **Lembrete**: Em SAAS, o usuário quer **sair rápido**. Facilite isso com componentes prontos, consistentes e performáticos.

**Agente Responsável**: GAMMA (Builder Prime)  
**Versão**: 3.0.0 | Stack Omega Compatible | SAAS-Only
```