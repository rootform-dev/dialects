# AWS icon-license spike

- Date: 2026-08-29
- Result: Pass
- Time box: 30 minutes

## Question

Do current official AWS terms clearly permit Rootform to redistribute and
mechanically optimize raw AWS Architecture Icon SVGs inside its binary/web pack?

## Verdict

No. AWS explicitly allows customers and partners to use current toolkits and
assets to create architecture diagrams and materials such as whitepapers,
presentations, data sheets, and posters. Current AWS Intellectual Property
License separately prohibits modifying, distributing, or creating derivative
works from AWS Content unless a separate license expressly permits it. The icon
page does not clearly grant redistribution of raw assets inside another
software product or modification through SVG optimization.

Rootform therefore vendors no AWS icon. AWS presentation identities
remain data-only and resolve through neutral local fallback. This preserves
semantics, offline operation, and provider-neutral rendering. Generated diagrams
may be reconsidered separately, but raw asset bundling needs written permission
or clearer official terms.

## Evidence

```text
official page: https://aws.amazon.com/architecture/icons/
archive: Icon-package_07312026.zip
archive bytes: 13,988,918
archive SHA-256: d2d166c453526471749d520e0db022c459abef759d2946cf2dd1d1c992dc6526
page snapshot SHA-256: 256bb7252eff6f58badc6585d25d944239f46367e447d23e988160f31bdd52a5
IP license updated: 2025-10-27
```

Official sources:

- <https://aws.amazon.com/architecture/icons/>
- <https://aws.amazon.com/legal/aws-ip-license-terms/>
- <https://aws.amazon.com/legal/trademark-guidelines/>

## Reconsideration trigger

Written AWS permission or a separate official architecture-icon license that
expressly permits raw redistribution and required transformations.
