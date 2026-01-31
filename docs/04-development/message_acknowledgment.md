# Message Acknowledgment Protocol

## Overview

This protocol ensures reliable inter-agent communication within the VividWalls MAS by implementing acknowledgment mechanisms that prevent information loss (FM-2.4) and ignored inputs (FM-2.5).

## Protocol Specification

### 1. Message Format

```json
{
  "message": {
    "id": "uuid-v4",
    "from": "sender_agent_id",
    "to": "receiver_agent_id",
    "timestamp": "ISO-8601",
    "workflow_execution_id": "n8n-execution-id",
    "correlation_id": "original-request-id",
    "priority": "high|medium|low",
    "requires_ack": true,
    "content": {
      "type": "task|query|response|notification",
      "data": {}
    }
  }
}
```

### 2. Acknowledgment Format

```json
{
  "acknowledgment": {
    "message_id": "original-message-uuid",
    "from": "receiver_agent_id",
    "to": "sender_agent_id",
    "timestamp": "ISO-8601",
    "status": "ACK|NACK",
    "reason": "optional-nack-reason",
    "processing_time_ms": 123
  }
}
```

## Implementation Rules

### Timeout Configuration

| Message Priority | Initial Timeout | Max Retries | Backoff Strategy |
|-----------------|-----------------|-------------|------------------|
| High | 5 seconds | 3 | Exponential (2x) |
| Medium | 10 seconds | 2 | Exponential (2x) |
| Low | 30 seconds | 1 | None |

### Retry Logic

```python
def send_with_acknowledgment(message, agent_connection):
    retries = 0
    timeout = get_initial_timeout(message.priority)
    
    while retries <= MAX_RETRIES[message.priority]:
        try:
            # Send message
            agent_connection.send(message)
            
            # Wait for acknowledgment
            ack = wait_for_ack(message.id, timeout)
            
            if ack and ack.status == "ACK":
                return True
            elif ack and ack.status == "NACK":
                handle_nack(ack)
                return False
                
        except TimeoutError:
            retries += 1
            timeout *= 2  # Exponential backoff
            log_retry(message, retries)
    
    # Max retries exceeded
    escalate_to_director(message)
    return False
```

## Acknowledgment Requirements by Agent Type

### Director-Level Agents
- **MUST** acknowledge all messages from Business Manager
- **MUST** acknowledge task completions from subordinate agents
- **SHOULD** acknowledge status updates within 10 seconds

### Task Agents
- **MUST** acknowledge task assignments within timeout window
- **MUST** send NACK if unable to process task
- **SHOULD** include reason code in NACK messages

### Platform Agents
- **MUST** acknowledge MCP operation requests
- **SHOULD** batch acknowledgments for bulk operations
- **MAY** use async acknowledgments for long-running tasks

## Failure Handling

### Acknowledgment Timeout
1. Log timeout event with full message context
2. Increment retry counter
3. If retries exhausted:
   - Mark agent as potentially unavailable
   - Escalate to parent director
   - Consider fallback agent

### NACK Handling
1. Parse reason code
2. Determine if recoverable:
   - Resource busy: Retry with backoff
   - Invalid request: Fix and resend
   - Capability missing: Route to different agent
3. Log NACK for analysis

### Circuit Breaker Integration
- After 5 consecutive timeouts: Open circuit for agent
- After 3 consecutive NACKs: Investigate agent health
- Circuit recovery: Test with low-priority message

## Monitoring & Metrics

### Key Metrics
- **Acknowledgment Rate**: (ACKs received / Messages sent) × 100
- **NACK Rate**: (NACKs received / Messages sent) × 100
- **Timeout Rate**: (Timeouts / Messages sent) × 100
- **Average Acknowledgment Time**: By agent and priority

### Alerting Thresholds
- Acknowledgment Rate < 95%: Warning
- Acknowledgment Rate < 90%: Critical
- Timeout Rate > 5%: Warning
- Timeout Rate > 10%: Critical

## Database Schema

```sql
-- Message tracking table
CREATE TABLE message_acknowledgments (
    message_id UUID PRIMARY KEY,
    sender_agent VARCHAR(100) NOT NULL,
    receiver_agent VARCHAR(100) NOT NULL,
    workflow_execution_id VARCHAR(100),
    correlation_id UUID,
    priority VARCHAR(10) DEFAULT 'medium',
    sent_at TIMESTAMP NOT NULL,
    acknowledged_at TIMESTAMP,
    ack_status VARCHAR(10), -- 'ACK', 'NACK', 'TIMEOUT'
    nack_reason TEXT,
    retry_count INT DEFAULT 0,
    processing_time_ms INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_sender_receiver (sender_agent, receiver_agent),
    INDEX idx_workflow (workflow_execution_id),
    INDEX idx_status (ack_status, sent_at)
);

-- Aggregated metrics for monitoring
CREATE TABLE acknowledgment_metrics (
    agent_id VARCHAR(100),
    hour_bucket TIMESTAMP,
    messages_sent INT DEFAULT 0,
    messages_acknowledged INT DEFAULT 0,
    messages_timeout INT DEFAULT 0,
    messages_nack INT DEFAULT 0,
    avg_ack_time_ms FLOAT,
    PRIMARY KEY (agent_id, hour_bucket)
);
```

## Implementation Checklist

- [ ] Add acknowledgment fields to agent message schema
- [ ] Implement acknowledgment tracking in PostgreSQL
- [ ] Create acknowledgment timeout handler
- [ ] Add retry logic with exponential backoff
- [ ] Integrate with circuit breaker system
- [ ] Build monitoring dashboard for acknowledgments
- [ ] Create alerting rules for acknowledgment failures
- [ ] Document acknowledgment patterns in agent prompts
- [ ] Test acknowledgment flow across all agent pairs
- [ ] Performance test under high message volume

## Example Implementations

### n8n Workflow Node
```javascript
// Acknowledgment sender node
const message = {
  id: $uuid(),
  from: "{{ $json.agent_id }}",
  to: "{{ $json.target_agent }}",
  timestamp: new Date().toISOString(),
  workflow_execution_id: "{{ $execution.id }}",
  requires_ack: true,
  content: $json.task_data
};

// Store message for tracking
await $db.insert('message_acknowledgments', {
  message_id: message.id,
  sender_agent: message.from,
  receiver_agent: message.to,
  sent_at: message.timestamp
});

// Send and wait for ack
const ack = await $sendWithAck(message, {{ $json.timeout_seconds }} * 1000);

if (!ack) {
  throw new Error(`No acknowledgment received from ${message.to}`);
}
```

### Agent System Prompt Addition
```markdown
## Message Acknowledgment Protocol

You MUST acknowledge all received messages within the timeout window:
- High priority: Acknowledge within 5 seconds
- Medium priority: Acknowledge within 10 seconds  
- Low priority: Acknowledge within 30 seconds

Send ACK for messages you can process.
Send NACK with reason if you cannot process the message.

Example acknowledgment:
{
  "acknowledgment": {
    "message_id": "<original-message-id>",
    "status": "ACK",
    "processing_time_ms": 230
  }
}
```

## Version History

- v1.0 (Current): Initial protocol specification
- v1.1 (Planned): Add batching support for bulk operations
- v2.0 (Future): Implement acknowledgment compression

---

*Last Updated: [Current Date]*  
*Status: Active*  
*Owner: Technology Director*