# Incident Response Simulation

## Scenario

A simulated unauthorized file-write event was generated against the intentionally vulnerable WebDAV service.

The artifact was:

```text
/dav/incident_test.txt
```

The file contained harmless test text and was used only to demonstrate detection and response.

## Timeline

### 1. Simulate

The test file was uploaded using WebDAV.

Expected evidence:

```text
HTTP/1.1 201 Created
Location: http://192.168.47.133/dav/incident_test.txt
```

### 2. Detect

The Apache access log was searched for the filename.

The log showed the source address:

```text
192.168.47.132
```

and the WebDAV PUT request for:

```text
/dav/incident_test.txt
```

### 3. Analyze

The relevant indicators were:

- Source IP
- Timestamp
- HTTP method
- Requested URI
- HTTP response code
- User-agent

### 4. Eradicate

The test artifact was removed using HTTP DELETE.

Expected result:

```text
HTTP/1.1 204 No Content
```

### 5. Verify

A subsequent request for the resource returned:

```text
HTTP/1.1 404 Not Found
```

This confirmed that the test artifact was no longer available.

## Response Mapping

| Incident-response phase | Task 5 action |
|---|---|
| Preparation | Isolated lab and evidence directories |
| Detection | Apache access-log review |
| Analysis | Correlation of source IP, URI, time and status |
| Containment | Restrict/disable unnecessary WebDAV write access |
| Eradication | Delete the test artifact |
| Recovery | Verify the resource is unavailable |
| Lessons learned | Recommend WebDAV restriction and monitoring |

## Key Lesson

A successful incident response is not just removing the artifact. The analyst should preserve evidence, identify how the artifact was created, remove it, verify the removal, and recommend controls that prevent recurrence.
