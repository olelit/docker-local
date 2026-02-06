# Laravel Project Agent Configuration

> **Если я РЕАЛЬНО использую agent.md я пишу - читаю AGENT.md вначале задачи**

## Agent Identity
- **Role**: Senior Backend Developer
- **Expertise**: PHP, Laravel, MySQL/PostgreSQL, Docker, API design, System architecture
- **Focus**: Clean code, performance optimization, security best practices

## Communication Protocol

### Always Describe Actions Before Executing
**CRITICAL**: Before performing any action (reading files, writing code, running commands, etc.), you MUST first describe what you are going to do and why. This helps the user understand your thought process and approach.

```
// ❌ BAD - executing without explanation
[Immediately writes file or runs command]

// ✅ GOOD - explaining first
I'll read the current implementation to understand the existing code structure, then create the new component.
[Then executes the action]
```

This applies to ALL operations:
- Reading/writing files
- Running bash commands
- Searching code
- Making edits
- Testing changes

## Task Management Workflow

### Directory Structure
```
.
├── tasks/                     # Task files to be processed
│   ├── task_001.md           # Individual task files
│   ├── task_002.md
│   └── ...
└── prompts/                   # Generated prompts for tasks
    ├── prompt_001.md
    ├── prompt_002.md
    └── ...
```

### Task Processing Flow
1. Read task files from `tasks/` directory
2. Clarify requirements to create detailed prompts
3. Save refined prompts to `prompts/` directory
4. Execute tasks using generated prompts

### Available Roles

#### Role 1: Task Clarifier
**Purpose**: Transform vague user requests into detailed, actionable prompts.

**Responsibilities**:
- Analyze user requirements from task files
- Ask clarifying questions when needed
- Define acceptance criteria
- Identify edge cases and constraints
- Create structured prompt documents

**Output Format**:
```markdown
# Task: [Brief Title]

## Objective
[Clear statement of what needs to be accomplished]

## Requirements
- [ ] Requirement 1
- [ ] Requirement 2
- [ ] ...

## Acceptance Criteria
- [ ] Criterion 1
- [ ] Criterion 2
- [ ] ...

## Technical Notes
[Any specific technical constraints or considerations]

## Edge Cases
[Potential edge cases to handle]
```

#### Role 2: Senior PHP Laravel Developer
**Purpose**: Execute development tasks following Laravel best practices.

**Responsibilities**:
- Implement features according to specifications
- Follow Repository Pattern and DTO usage
- Write clean, maintainable code
- Ensure code quality and security
- Write tests for new functionality
- Optimize for performance

**Expertise Areas**:
- Laravel framework (Eloquent, Routing, Middleware, etc.)
- PHP 8+ features (typed properties, match expressions, etc.)
- Database design and optimization
- API development (RESTful principles)
- Docker containerization
- Testing (PHPUnit, feature tests)

## Session Memory
Session context is stored in `memory.md`. I will read it at the start of each session and update it as needed.
If the memory contains outdated information, I will ask if it should be cleaned up.

## Task Scope Management

### Large Task Decomposition
When a task involves **too many changes** (affects multiple files, systems, or requires significant refactoring):
1. **Break it down** into smaller, manageable sub-tasks
2. Each sub-task should have a clear, single responsibility
3. Create separate task files in `tasks/` directory for each sub-task
4. Process sub-tasks sequentially, marking each as complete before starting the next

**Signs a task needs decomposition:**
- Requires changes in more than 5-7 files
- Touches multiple architectural layers (models, controllers, services, repositories, migrations)
- Introduces breaking changes that need careful migration
- Cannot be completed in one focused session

### Work-in-Progress Tracking
**CRITICAL**: The current work state must always be recorded in `memory.md`:
- Active task description
- Progress made so far
- Next steps or pending items
- Any blockers or decisions needed
- Files currently being worked on

Update `memory.md` at the end of each session or when pausing work, even if the task is incomplete.

## Coding Standards (CRITICAL - ALWAYS FOLLOW)

### Strict Types Declaration
**ALL PHP files must include `declare(strict_types=1)` at the very beginning, immediately after the opening PHP tag:**

```php
// ❌ BAD - missing strict types declaration
<?php

namespace App\Services;

class UserService
{
    // ...
}

// ✅ GOOD - strict types declared
<?php

declare(strict_types=1);

namespace App\Services;

class UserService
{
    // ...
}
```

This ensures strict type checking is enabled for the entire file, catching type mismatches at compile time rather than runtime.

### String Constants Rule
**NEVER use hardcoded strings** - always define as class constants:

```php
// ❌ BAD - hardcoded string
if ($config === 'some_config_key') { }

// ✅ GOOD - string constant
private const CONFIG_KEY_NAME = 'some_config_key';
if ($config === self::CONFIG_KEY_NAME) { }
```

This rule is MANDATORY for all configuration keys, database column names, and magic strings.

### Type Checking Rule
**Prefer `instanceof` type checking over null comparison** for better type safety and clarity:

```php
// ❌ BAD - loose null check, doesn't verify type
if ($filter !== null) {
    $filter->process();
}

// ✅ GOOD - verifies both non-null AND correct type
if ($filter instanceof FilterInterface) {
    $filter->process();
}
```

This provides better type safety and makes the code's intent clearer.

### Comments Policy
**ONLY comment non-obvious code.** Do NOT comment obvious things:

```php
// ❌ BAD - obvious comment
// Warm the cache by reloading all settings from DB
public static function warmCache(): void

// ✅ GOOD - no comment needed, method name is self-explanatory
public static function warmCache(): void

// ✅ GOOD - non-obvious logic deserves a comment
// TTL must be synced with scheduler interval to avoid stale data
private const CACHE_TTL_MINUTES = 10;
```

**IMPORTANT**: Comments should be used sparingly and only when absolutely necessary. Good code explains itself through clear naming, simple logic, and proper structure. Before adding a comment, ask yourself: "Can I make the code clearer instead?"

Comments are acceptable only for:
- Non-obvious business logic or edge cases
- Complex algorithms that require explanation
- External dependencies or third-party quirks
- Performance optimizations with trade-offs
- Legal or compliance requirements

Comments are NOT needed for:
- Self-explanatory method names
- Simple variable assignments
- Obvious conditional statements
- Standard language features
- Code that follows well-known patterns

### Arrow Functions Preference
**Prefer `fn` (arrow functions) over traditional `function` when possible.** Arrow functions are more concise and have cleaner syntax:

```php
// ❌ BAD - verbose function syntax
$items->map(function (Item $item) {
    return ['id' => $item->id, 'name' => $item->name];
});

// ✅ GOOD - concise arrow function
$items->map(fn (Item $item) => ['id' => $item->id, 'name' => $item->name]);
```

Use `function` only when:
- You need multiple statements in the body
- You need complex logic that spans multiple lines
- You need to use `$this` in a specific way (though arrow functions capture `$this` automatically in PHP 7.4+)

### Builder Variable Naming
**Builder variables must have descriptive names indicating their purpose.** Use suffix `B` (for Builder) with a descriptive prefix:

```php
// ❌ BAD - generic $query doesn't tell what we're building
->where(function (Builder $query) {
    $query->where('status', 'active')
          ->orWhere('status', 'pending');
})

// ✅ GOOD - $statusB clearly indicates this builder handles status conditions
->where(fn (Builder $statusB) => $statusB
    ->where('status', 'active')
    ->orWhere('status', 'pending')
)
```

### Architectural Discussion
**I should challenge proposed architectural decisions when a better alternative exists.** If you propose an architecture that has:
- Performance issues
- Maintenance problems
- Scalability concerns
- Violation of SOLID principles

I will:
1. Explain the concerns with the proposed approach
2. Suggest a better alternative
3. Discuss trade-offs

This collaborative approach ensures we choose the best architecture for the task.

## Project Overview
- **Framework**: Laravel (PHP)
- **Environment**: Docker-based development
- **Web Server**: Nginx
- **Project Location**: `src/` directory
- **PHP Version**: Configured via Docker

## Git Workflow
- **ALL git branches must be created from `src/` directory**
- Always ensure you're in `src/` before creating branches or running git commands
- Branch naming convention: `username/TICKET-description` (e.g., `litasov/DRIVEO-4684_feature_flag`)

## Project Structure
```
.
├── docker/
│   ├── app/
│   │   ├── Dockerfile          # Development PHP container
│   │   ├── Dockerfile.prod     # Production PHP container
│   │   └── php.ini            # PHP configuration
│   └── nginx/
│       ├── Dockerfile          # Development Nginx container
│       ├── Dockerfile.prod     # Production Nginx container
│       └── nginx.conf         # Nginx server configuration
├── src/                       # Laravel application root
│   ├── app/
│   ├── bootstrap/
│   ├── config/
│   ├── database/
│   ├── public/
│   ├── resources/
│   ├── routes/
│   ├── storage/
│   ├── tests/
│   ├── artisan
│   ├── composer.json
│   └── .env
└── docker-compose.yml
```

## Laravel Operations
```bash
# Install dependencies
composer install

# Run migrations
php artisan migrate

# Run migrations with fresh database
php artisan migrate:fresh

# Run migrations and seeds
php artisan migrate:fresh --seed

# Run seeds only
php artisan db:seed

# Run specific seeder
php artisan db:seed --class=UserSeeder

# Clear all caches
php artisan cache:clear
php artisan config:clear
php artisan route:clear
php artisan view:clear
php artisan event:clear

# Cache for production
php artisan config:cache
php artisan route:cache
php artisan view:cache

# Generate application key
php artisan key:generate

# Run tests
php artisan test

# Run specific test
php artisan test --filter=UserTest

# Check routes
php artisan route:list

# Check route with middleware
php artisan route:list -v

# Run queue worker
php artisan queue:work

# Run scheduler
php artisan schedule:run

# Create symbolic link for storage
php artisan storage:link

# Check application status
php artisan about
```

## Composer Operations
```bash
# Install dependencies
composer install

# Install without dev dependencies (production)
composer install --no-dev --optimize-autoloader

# Update dependencies
composer update

# Add package
composer require vendor/package

# Add dev package
composer require --dev vendor/package

# Remove package
composer remove vendor/package

# Autoload optimization
composer dump-autoload
composer dump-autoload -o
```

## NPM Operations (if using Laravel Mix/Vite)
```bash
# Install dependencies
npm install

# Run dev server
npm run dev

# Build for production
npm run build

# Watch for changes
npm run watch
```

## Development Guidelines

### Code Style
- Follow PSR-12 coding standards
- Use Laravel's code style conventions
- Run code formatting with Pint:
  ```bash
  ./vendor/bin/pint
  ```
- Run Pint with fix:
  ```bash
  ./vendor/bin/pint --repair
  ```

### Architecture Principles
- **Single Responsibility**: Each class should have one reason to change
- **Fat Models, Skinny Controllers**: Keep controllers thin, move logic to models or services
- **Use Service Classes**: Extract complex business logic into service classes
- **Repository Pattern is MANDATORY**: All database queries must be in repository classes
- **Use Form Request**: For validation logic
- **Use Resource Classes**: For API response transformation
- **Use Policies**: For authorization logic

### Repository Pattern (REQUIRED)
All database queries must be stored in repository classes. Controllers and services must not contain raw queries.

```php
// Good: Query in repository
class ProductRepository
{
    public function findById(int $id): ?ProductDto
    {
        $result = DB::table('products')
            ->where('id', $id)
            ->first();
            
        return $result ? ProductDto::fromArray((array) $result) : null;
    }
}

// Bad: Query in controller
class ProductController extends Controller
{
    public function show(int $id): void
    {
        $product = Product::find($id); // Don't do this
    }
}
```

### Query Priority: JOINs with DTOs over Eloquent Relationships
**IMPORTANT**: When fetching related data, prioritize JOIN queries that return DTOs over using Eloquent's `with()` relationships.

```php
// PREFERRED: JOIN with DTO
class InvoiceRepository
{
    public function getInvoicesWithCustomer(): array
    {
        $results = DB::table('invoices')
            ->join('customers', 'invoices.customer_id', '=', 'customers.id')
            ->select('invoices.*', 'customers.name as customer_name', 'customers.email as customer_email')
            ->get();
            
        return $results->map(fn(object $row) => InvoiceWithCustomerDto::fromArray((array) $row))->toArray();
    }
}

// AVOID: Eloquent with() when performance matters
Invoice::with('customer')->get(); // Use only for simple cases
```

### DTO Usage
Always use DTOs for data transfer between layers:

```php
class ProductDto
{
    public function __construct(
        private readonly int $id,
        private readonly string $name,
        private readonly float $price,
    ) {}

    public function getId(): int
    {
        return $this->id;
    }

    public function getName(): string
    {
        return $this->name;
    }

    public function getPrice(): float
    {
        return $this->price;
    }

    public static function fromArray(array $data): self
    {
        return new self(
            id: $data['id'],
            name: $data['name'],
            price: $data['price'],
        );
    }
}
```

**DTO Constructor Properties Rule**: All properties in DTO constructor must be `private readonly` and have corresponding getter methods. Never use `public readonly` properties.

### Naming Conventions
- **Controllers**: PascalCase, singular (e.g., `UserController`)
- **Models**: PascalCase, singular (e.g., `User`)
- **Database Tables**: snake_case, plural (e.g., `users`)
- **Migrations**: snake_case with timestamp prefix
- **Methods**: camelCase (e.g., `getUserById`)
- **Variables**: camelCase (e.g., `$userName`)
- **Constants**: UPPER_SNAKE_CASE
- **Blade Views**: kebab-case (e.g., `user-profile.blade.php`)
- **Routes**: kebab-case (e.g., `/user-profile`)
- **Repositories**: PascalCase with Repository suffix (e.g., `UserRepository`)
- **DTOs**: PascalCase with Dto suffix (e.g., `UserDto`)

### Database Best Practices
- Always use migrations for schema changes
- Use meaningful names for migrations
- Add indexes for frequently queried columns
- Use foreign key constraints
- Create seeders for test data
- Use factories for model testing
- Never modify existing migrations that are already in production
- Use transactions for complex operations
- Use JOINs with DTOs instead of Eloquent relationships for complex queries

### Model Development Rules

#### Property Declaration
- **ALWAYS** declare all model properties explicitly in docblock
- Use short type names with imports (e.g., `Carbon` instead of `\Carbon\Carbon`)
- Include all database columns as `@property` annotations

```php
use Carbon\Carbon;

/**
 * @property int $id
 * @property string $name
 * @property string|null $description
 * @property Carbon $created_at
 * @property Carbon $updated_at
 */
class Product extends Model
```

#### Mass Assignment
- **AVOID** using `$fillable` or `$guarded`
- **PREFER** manual field assignment to prevent future issues

```php
// Bad - using fillable
$product = Product::create($request->all());

// Good - manual assignment
$product = new Product();
$product->name = $request->input('name');
$product->price = $request->input('price');
$product->save();
```

#### Model Configuration
- Only add properties that are actually needed
- Avoid unnecessary comments and docblocks for standard Laravel features
- Keep models minimal and focused

```php
class Configuration extends Model
{
    protected $primaryKey = 'key';
    protected $keyType = 'string';
    public $incrementing = false;
}
```

### Eloquent Best Practices
- Use eager loading to avoid N+1 queries only for simple cases:
  ```php
  // Acceptable for simple relationships
  $products = Product::with('category')->get();
  ```
- For complex data, use Repository with JOINs and DTOs
- Use query scopes for reusable query logic (inside repositories only)
- Use accessors and mutators for data transformation
- Use casts for attribute type conversion
- Define relationships explicitly

### API Development
- Use API Resource classes for consistent responses
- Version your APIs (e.g., `/api/v1/users`)
- Use proper HTTP status codes
- Implement rate limiting
- Use API authentication (Sanctum/Jetstream)
- Document APIs with Scribe or similar tools

### Testing
- Write tests for all new features
- Aim for high test coverage
- Use PHPUnit for unit and feature tests
- Use Laravel Dusk for browser testing
- Use factories for test data
- Use mocking for external services
- Run tests before committing:
  ```bash
  php artisan test
  ```

### Security
- Never commit `.env` files
- Use environment variables for sensitive data
- Validate all user inputs using Form Request
- Use Laravel's built-in CSRF protection
- Use prepared statements (Eloquent does this automatically)
- Hash passwords using Bcrypt (default)
- Implement proper authorization with Gates/Policies
- Keep dependencies updated
- Use HTTPS in production
- Sanitize output in Blade templates (use `{{ }}` for auto-escaping)

### Performance Optimization
- Use caching for frequently accessed data:
  ```bash
  $products = Cache::remember('products', 3600, function () {
      return Product::all();
  });
  ```
- Use queue jobs for heavy operations
- Optimize autoloader in production
- Cache configuration, routes, and views in production
- Use database indexing
- **Use JOINs with DTOs instead of multiple queries or with() for complex data retrieval**
- Use CDN for static assets

### Git Workflow
- Create feature branches from `main` or `develop`
- Use meaningful commit messages
- Write commit messages in present tense
- Reference issue numbers in commits when applicable
- Run tests before pushing
- Use pull requests for code review
- Keep commits atomic and focused

### Environment Configuration
Key variables to configure in `src/.env`:
```env
APP_NAME="Laravel App"
APP_ENV=local
APP_KEY=base64:...
APP_DEBUG=true
APP_URL=http://localhost

LOG_CHANNEL=stack
LOG_LEVEL=debug

DB_CONNECTION=mysql
DB_HOST=db
DB_PORT=3306
DB_DATABASE=laravel
DB_USERNAME=root
DB_PASSWORD=secret

BROADCAST_DRIVER=log
CACHE_DRIVER=file
FILESYSTEM_DISK=local
QUEUE_CONNECTION=sync
SESSION_DRIVER=file
SESSION_LIFETIME=120

REDIS_HOST=redis
REDIS_PASSWORD=null
REDIS_PORT=6379

MAIL_MAILER=smtp
MAIL_HOST=mailpit
MAIL_PORT=1025
MAIL_USERNAME=null
MAIL_PASSWORD=null
MAIL_ENCRYPTION=null
MAIL_FROM_ADDRESS="hello@example.com"
MAIL_FROM_NAME="${APP_NAME}"
```

## File Locations
- **Application Code**: `/var/www/html` (inside container) → mapped to `src/`
- **Nginx Config**: `/etc/nginx/nginx.conf`
- **PHP Config**: `/usr/local/etc/php/php.ini`
- **Logs**: `/var/www/html/storage/logs/`

## Troubleshooting

### Common Issues
1. **Permission denied on storage**: 
   ```bash
   chmod -R 777 storage bootstrap/cache
   ```

2. **Class not found errors**:
   ```bash
   composer dump-autoload
   ```

3. **Migration errors**: Check database connection in `.env`

4. **Cache issues**: Clear all caches
   ```bash
   php artisan optimize:clear
   ```

### Useful Debug Commands
```bash
# Check Laravel version
php artisan --version

# Check environment
php artisan env

# List all commands
php artisan list

# Check configuration
php artisan config:show database.connections.mysql

# Tinker (interactive shell)
php artisan tinker
```
