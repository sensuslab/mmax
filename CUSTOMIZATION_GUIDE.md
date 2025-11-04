# Kortix/Suna Customization Guide

This guide covers how to customize the **UI front page** and **agentic flows** from the admin perspective.

---

## 📋 Table of Contents
1. [UI Front Page Customization](#ui-front-page-customization)
2. [Agentic Flow Customization](#agentic-flow-customization)
3. [Quick Reference](#quick-reference)

---

## 🎨 UI Front Page Customization

### Main Configuration Files

#### 1. **Site Metadata** - `/frontend/src/lib/site.ts`
Basic site information that appears across the application:
```typescript
export const siteConfig = {
  name: 'Kortix',                    // Change your brand name
  url: 'https://kortix.com',         // Your domain
  description: '...',                // Meta description
  links: {
    twitter: 'https://x.com/kortix',     // Social links
    github: 'https://github.com/kortix-ai/',
    linkedin: 'https://www.linkedin.com/company/kortix/',
  },
};
```

#### 2. **Home Page Content** - `/frontend/src/lib/home.tsx`
This is the **PRIMARY FILE** for customizing your front page. Key sections:

**🆔 Hero Section (Lines 83-116)**
```typescript
hero: {
  badgeIcon: (...);              // SVG icon for badge
  badge: '100% OPEN SOURCE',     // Badge text
  githubUrl: '...',              // GitHub link
  title: 'Kortix – Build, manage and train your AI Workforce.',
  description: '...',
  inputPlaceholder: 'Ask Kortix to...',  // Input field placeholder
}
```

**💰 Pricing Tiers (Lines 117-299)**
```typescript
cloudPricingItems: [
  {
    name: 'Plus',              // Plan name
    price: '$20',              // Monthly price
    yearlyPrice: '$204',       // Yearly price
    description: '...',        // Plan description
    features: [                // Feature list
      '2,000 credits/m',
      '5 custom agents',
      // ...
    ],
    isPopular: true/false,     // Highlight popular plan
  },
  // ... more plans
]
```

**🏢 Company Showcase (Lines 300-500)**
```typescript
companyShowcase: {
  companyLogos: [
    {
      id: 1,
      name: 'Company Name',
      logo: (<svg>...</svg>),  // Your logo SVG
    },
    // ... add your company logos
  ],
}
```

**✨ Feature Section (Lines 501-581)**
```typescript
bentoSection: {
  title: 'Empower Your Workflow with Kortix',
  description: '...',
  items: [
    {
      title: 'Feature Title',
      description: 'Feature description',
      content: <AnimationComponent />,  // Custom component or React element
    },
    // ... more features
  ],
}
```

**❓ FAQ Section (Lines 1179-1221)**
```typescript
faqSection: {
  title: 'Frequently Asked Questions',
  faQitems: [
    {
      question: 'Your question?',
      answer: 'Your answer.',
    },
    // ... more FAQs
  ],
}
```

**🔗 Footer Links (Lines 1232-1273)**
```typescript
footerLinks: [
  {
    title: 'Kortix',
    links: [
      { id: 1, title: 'About', url: 'https://kortix.com' },
      { id: 3, title: 'Contact', url: 'mailto:hey@kortix.com' },
      // ... more links
    ],
  },
]
```

### Customization Examples

#### ✏️ **Example 1: Change Your Brand Name**
Edit `/frontend/src/lib/site.ts`:
```typescript
export const siteConfig = {
  name: 'YourBrand',  // Changed from 'Kortix'
  // ...
};
```

Also update `/frontend/src/lib/home.tsx`:
```typescript
hero: {
  title: 'YourBrand – Your custom tagline here.',
  // ...
}
```

#### 🎨 **Example 2: Customize Hero Section**
Edit `/frontend/src/lib/home.tsx` lines 83-116:
```typescript
hero: {
  badge: 'YOUR BADGE TEXT',
  title: 'Your Custom Title',
  description: 'Your custom description',
  inputPlaceholder: 'Ask YourBrand to...',
}
```

#### 💰 **Example 3: Update Pricing**
Edit `/frontend/src/lib/home.tsx` lines 117-299:
```typescript
cloudPricingItems: [
  {
    name: 'Starter',
    price: '$10',
    yearlyPrice: '$100',
    description: 'For individuals',
    features: [
      '1,000 credits/m',
      '2 custom agents',
      'Basic features',
    ],
    isPopular: true,
  },
  // ...
]
```

#### 🏢 **Example 4: Add Your Company Logos**
Edit `/frontend/src/lib/home.tsx` lines 300-500:
```typescript
companyShowcase: {
  companyLogos: [
    {
      id: 1,
      name: 'Your Company',
      logo: (
        <svg width="110" height="31" ...>
          {/* Your SVG logo */}
        </svg>
      ),
    },
    // ... add more
  ],
}
```

---

## 🤖 Agentic Flow Customization

### Agent Configuration Structure

Agents can be customized through the admin dashboard at:
**Path:** `/dashboard/agents/config/[agentId]/`

The page has 5 main configuration sections:

---

### 1. **Instructions Screen** - `/frontend/src/app/(dashboard)/agents/config/[agentId]/screens/instructions-screen.tsx`

**Purpose:** Define how the agent behaves and what it's trained to do.

**Customizable Elements:**
- **System Instructions**: Detailed behavior prompts
- **User Instructions**: How users should interact
- **Agent Personality**: Tone and style guidelines
- **Task Examples**: Sample tasks the agent can handle

**Key Files:**
- `frontend/src/app/(dashboard)/agents/config/[agentId]/screens/instructions-screen.tsx`

**Admin Controls:**
- Text area for editing instructions
- Real-time preview
- Save/Update buttons

---

### 2. **Tools Screen** - `/frontend/src/app/(dashboard)/agents/config/[agentId]/screens/tools-screen.tsx`

**Purpose:** Configure what tools and capabilities the agent has access to.

**Customizable Tools:**
- Web Search (Tavily API)
- Web Scraping (Firecrawl)
- File Processing
- Code Execution (Daytona Sandbox)
- Image Analysis
- Document Generation
- Data Analysis
- And more...

**Key Files:**
- `frontend/src/app/(dashboard)/agents/config/[agentId]/screens/tools-screen.tsx`
- `backend/core/tools/` - Tool implementations

**Admin Controls:**
- Toggle tools on/off
- Configure tool parameters
- Set tool-specific instructions
- Test tools individually

**Tool Categories:**
```typescript
// Search & Research
- Web Search (Tavily)
- Paper Search
- People Search (Exa)

 // Content Processing
- File Reader
- Image Analysis
- Vision Tool
- Shell Execution

 // Data & Analytics
- Code Execution
- Data Analysis
- Visualization

 // Integrations
- Composio (200+ tools)
- Google Services
- Slack, Discord, etc.
```

---

### 3. **Integrations Screen** - `/frontend/src/app/(dashboard)/agents/config/[agentId]/screens/integrations-screen.tsx`

**Purpose:** Connect external services and APIs to extend agent capabilities.

**Available Integrations:**

**🔌 Composio** (200+ integrations)
- GitHub
- Google Drive/Docs/Sheets
- Slack
- Notion
- Jira
- Figma
- And many more...

**🌐 Web Services**
- REST APIs
- Webhooks
- Custom endpoints

**☁️ Cloud Services**
- AWS
- Google Cloud
- Supabase
- Firebase

**Key Files:**
- `frontend/src/app/(dashboard)/agents/config/[agentId]/screens/integrations-screen.tsx`
- `backend/core/composio_integration/`

**Admin Controls:**
- Browse available integrations
- Authenticate with API keys
- Configure connection settings
- Test integrations
- Enable/disable specific integrations

---

### 4. **Knowledge Screen** - `/frontend/src/app/(dashboard)/agents/config/[agentId]/screens/knowledge-screen.tsx`

**Purpose:** Upload documents and data sources for the agent to reference.

**Knowledge Sources:**
- **Documents**: PDF, DOCX, TXT, MD
- **Websites**: URLs to scrape
- **Databases**: Direct database connections
- **APIs**: Data from external sources
- **Files**: Upload local files

**Key Files:**
- `frontend/src/app/(dashboard)/agents/config/[agentId]/screens/knowledge-screen.tsx`

**Admin Controls:**
- Upload files (drag & drop)
- Add website URLs
- Connect databases
- Configure knowledge base settings
- Set knowledge base priorities
- Test knowledge retrieval

**Knowledge Management:**
- Tag documents
- Set document categories
- Configure relevance scoring
- Update/delete knowledge

---

### 5. **Triggers Screen** - `/frontend/src/app/(dashboard)/agents/config/[agentId]/screens/triggers-screen.tsx`

**Purpose:** Configure automated actions and event-driven workflows.

**Trigger Types:**
- **Schedule-based**: Run at specific times (cron)
- **Event-based**: React to system events
- **Webhook-based**: Trigger via HTTP requests
- **File-based**: Monitor file changes
- **Database triggers**: React to data changes

**Key Files:**
- `frontend/src/app/(dashboard)/agents/config/[agentId]/screens/triggers-screen.tsx`
- `backend/core/triggers/`

**Admin Controls:**
- Create new triggers
- Configure trigger conditions
- Set action workflows
- Enable/disable triggers
- View trigger history
- Test triggers

**Example Triggers:**
```typescript
// Scheduled Trigger
{
  type: 'schedule',
  cron: '0 9 * * *',  // Run daily at 9 AM
  action: 'generate_report'
}

// Webhook Trigger
{
  type: 'webhook',
  endpoint: '/agent/trigger',
  action: 'process_data'
}

// Event Trigger
{
  type: 'event',
  event: 'file_uploaded',
  action: 'analyze_document'
}
```

---

### Agent Avatar Customization

**Path:** `/dashboard/agents/config/[agentId]/page.tsx` (Lines 51-72)

**Customizable Elements:**
- **Name**: Agent display name
- **Icon**: Choose from icon library or upload custom
- **Icon Color**: Customize icon color
- **Background Color**: Customize icon background

**Admin Controls:**
- Edit button in header
- Avatar preview
- Color picker
- Icon selector

---

### Backend Agent Configuration

**Core Files:**
- `backend/core/agent_service.py` - Agent lifecycle management
- `backend/core/agent_crud.py` - Agent CRUD operations
- `backend/core/agent_runs.py` - Agent execution logic
- `backend/core/run.py` - Main execution engine
- `backend/core/threads.py` - Conversation management

**Environment Variables:**
```bash
# In backend/.env
DAYTONA_API_KEY=...           # For sandbox execution
COMPOSIO_API_KEY=...          # For integrations
ANTHROPIC_API_KEY=...         # For LLM
OPENAI_API_KEY=...            # Alternative LLM
TAVILY_API_KEY=...            # For web search
FIRECRAWL_API_KEY=...         # For web scraping
```

---

## 🚀 Quick Reference

### Front Page Customization Checklist

- [ ] **Brand Identity** (site.ts)
  - [ ] Change site name
  - [ ] Update description
  - [ ] Add social links

- [ ] **Hero Section** (home.tsx)
  - [ ] Update badge text
  - [ ] Customize title & description
  - [ ] Change input placeholder

- [ ] **Pricing**
  - [ ] Update plan names
  - [ ] Modify pricing
  - [ ] Add/remove features
  - [ ] Mark popular plans

- [ ] **Features**
  - [ ] Customize feature titles
  - [ ] Update descriptions
  - [ ] Replace animations

- [ ] **Company Logos**
  - [ ] Add your logo SVGs
  - [ ] Update company names

- [ ] **FAQ**
  - [ ] Add your questions
  - [ ] Write answers

- [ ] **Footer**
  - [ ] Update links
  - [ ] Add contact info

### Agent Configuration Checklist

- [ ] **Basic Settings**
  - [ ] Agent name
  - [ ] Avatar/icon
  - [ ] Colors

- [ ] **Instructions**
  - [ ] Write system instructions
  - [ ] Add user guidelines
  - [ ] Define personality

- [ ] **Tools**
  - [ ] Enable web search
  - [ ] Configure file processing
  - [ ] Set up code execution
  - [ ] Add custom tools

- [ ] **Integrations**
  - [ ] Connect APIs
  - [ ] Set up webhooks
  - [ ] Configure services

- [ ] **Knowledge**
  - [ ] Upload documents
  - [ ] Add websites
  - [ ] Configure data sources

- [ ] **Triggers**
  - [ ] Set up schedules
  - [ ] Configure webhooks
  - [ ] Add event triggers

---

## 💡 Tips for Customization

### Front Page Tips
1. **Keep it simple**: Don't overcrowd the hero section
2. **Be specific**: Clear value proposition
3. **Show pricing early**: Build trust
4. **Use real logos**: Fake logos look unprofessional

### Agent Tips
1. **Start with instructions**: Clear prompts = better agents
2. **Enable only needed tools**: Don't overwhelm the agent
3. **Test thoroughly**: Use the test functionality
4. **Version your agents**: Save configuration backups

### Best Practices
1. **Version Control**: Commit changes to git
2. **Environment Parity**: Match dev/staging/prod configs
3. **Documentation**: Document your customizations
4. **Testing**: Always test in staging first

---

## 📚 Additional Resources

- **Official Docs**: https://github.com/Kortix-ai/Suna
- **Configuration Reference**: `/frontend/src/lib/config.ts`
- **Agent Examples**: Check existing agents in dashboard
- **Component Library**: `/frontend/src/components/ui/`

---

## 🆘 Troubleshooting

### Front Page Not Updating?
```bash
# Restart the development server
cd frontend
npm run dev
```

### Agent Not Responding?
```bash
# Check backend logs
cd backend
uv run api.py
# Or check worker logs
uv run dramatiq --processes 4 --threads 4 run_agent_background
```

### Tools Not Working?
1. Verify API keys in `.env`
2. Check tool permissions
3. Test tools individually
4. Review logs

### Integration Failing?
1. Verify API credentials
2. Check webhook URLs
3. Test API endpoints
4. Review integration logs

---

## 📞 Support

- **GitHub Issues**: https://github.com/Kortix-ai/Suna/issues
- **Discord**: https://discord.gg/Py6pCBUUPw
- **Email**: support@kortix.com

---

Happy customizing! 🎉
